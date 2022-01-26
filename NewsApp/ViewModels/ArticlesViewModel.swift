//
//  ArticlesViewModel.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import Foundation

struct FetchTaskToken: Equatable {
    var category: Category
    var token: Date
}

fileprivate let dateFormatter = DateFormatter()

@MainActor
class ArticlesViewModel: ObservableObject {
    
    @Published var phase = DataFetch<[Articles]>.empty
    @Published var fetchTaskToken: FetchTaskToken {
        didSet {
            if oldValue.category != fetchTaskToken.category {
                selectedMenuItemId = MenuItem.category(fetchTaskToken.category).id
            }
        }
    }

    private var selectedMenuItemId: MenuItem.ID?

    private let newsAPI = NewsAPI.shared
    private let pagingData = PagingData(itemsPerPage: 10, maxPageLimit: 5)
    
    private let cache = InMemoryCache<[Articles]>(expirationInterval: 5 * 60)

    var lastRefreshedDateText: String {
        dateFormatter.timeStyle = .short
        return "Last refreshed at: \(dateFormatter.string(from: fetchTaskToken.token))"
    }
    
    var articles: [Articles] {
        phase.value ?? []
    }
    
    var isFetchingNextPage: Bool {
        if case .fetchingNextPage = phase {
            return true
        }
        return false
    }
    
    init(articles: [Articles]? = nil, selectedCategory: Category = .general) {
        if let articles = articles {
            self.phase = .success(articles)
        } else {
            self.phase = .empty
        }
        self.fetchTaskToken = FetchTaskToken(category: selectedCategory, token: Date())
    }
    
    func refreshTask() async {
        await cache.removeValue(forKey: fetchTaskToken.category.rawValue)

        fetchTaskToken.token = Date()
    }
    
    func loadFirstPage() async {
        if Task.isCancelled { return }
        let category = fetchTaskToken.category
        if let articles = await cache.value(forKey: category.rawValue) {
            await print("PAGING: From Cache, Current Page \(pagingData.currentPage), maxPageLimit: \(pagingData.maxPageLimit)")
            phase = .success(articles)
            return
        }
                
        phase = .empty
        do {
            await pagingData.reset()
            
            let articles = try await pagingData.loadNextPage(dataFetchProvider: loadArticles(page:))
            await cache.setValue(articles, forKey: category.rawValue)
            
            if Task.isCancelled { return }
            phase = .success(articles)
        } catch {
            if Task.isCancelled { return }
            print(error.localizedDescription)
            phase = .failure(error)
        }
    }
    
    func loadNextPage() async {
        if Task.isCancelled { return }
        
        var articles = self.phase.value ?? []
        phase = .fetchingNextPage(articles)
        
        do {
            let nextArticles = try await pagingData.loadNextPage(dataFetchProvider: loadArticles(page:))
            if Task.isCancelled { return }
            
            articles += nextArticles
            await cache.setValue(articles, forKey: fetchTaskToken.category.rawValue)
            
            phase = .success(articles)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func loadArticles(page: Int) async throws -> [Articles] {
        let articles = try await newsAPI.fetch(
            from: fetchTaskToken.category,
            page: page,
            pageSize: pagingData.itemsPerPage
        )
        if Task.isCancelled { return [] }
        return articles
    }
}
