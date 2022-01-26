//
//  NewsTabView.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import SwiftUI

struct NewsTabView: View {
    
    @StateObject var articleNewsVM: ArticlesViewModel
    
    init(articles: [Articles]? = nil, category: Category = .general) {
        self._articleNewsVM = StateObject(wrappedValue: ArticlesViewModel(articles: articles, selectedCategory: category))
    }
    
    var body: some View {
        ArticleListView(articles: articleNewsVM.articles, isFetchingNextPage: articleNewsVM.isFetchingNextPage, nextPageHandler: { await articleNewsVM.loadNextPage() })
            .overlay(overlayView)
            .task(id: articleNewsVM.fetchTaskToken, loadTask)
            .refreshable(action: refreshTask)
            .navigationTitle(articleNewsVM.fetchTaskToken.category.text)
            .navigationBarItems(trailing: navigationBarItem)
    }
    
    @ViewBuilder
    private var overlayView: some View {
        
        switch articleNewsVM.phase {
        case .empty:
            ProgressView()
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No Articles", image: nil)
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: refreshTask)
        default: EmptyView()
        }
    }
    
    @Sendable
    private func loadTask() async {
        await articleNewsVM.loadFirstPage()
    }
    
    @Sendable
    private func refreshTask() {
        Task {
            await articleNewsVM.refreshTask()
        }
    }
    
    @ViewBuilder
    private var navigationBarItem: some View {
            Menu {
                Picker("Category", selection: $articleNewsVM.fetchTaskToken.category) {
                    ForEach(Category.allCases) {
                        Text($0.text).tag($0)
                    }
                }
            } label: {
                Image(systemName: "line.horizontal.3")
                    .imageScale(.large)
                    .foregroundColor(.black)
            }
        }

}

struct NewsTabView_Previews: PreviewProvider {
    
    static var previews: some View {
        NewsTabView(articles: Articles.previewData)
    }
}
