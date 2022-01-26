//
//  ArticlesListView.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import SwiftUI

struct ArticleListView: View {
    
    @State private var selectedArticleURL: URL?
    
    let articles: [Articles]
    var isFetchingNextPage = false
    var nextPageHandler: (() async -> ())? = nil
    
    var body: some View {
        rootView
        .sheet(item: $selectedArticleURL) {
            SafariView(url: $0)
                .edgesIgnoringSafeArea(.bottom)
                .id($0)
        }
    }
    
    @ViewBuilder
    private var bottomProgressView: some View {
        Divider()
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.padding()
    }
    
    
    private var listView: some View {
        List {
            ForEach(articles) { article in
                if let nextPageHandler = nextPageHandler, article == articles.last {
                    listRowView(for: article)
                        .task { await nextPageHandler() }
                    
                    if isFetchingNextPage {
                        bottomProgressView
                    }
                    
                } else {
                    listRowView(for: article)
                }
            }
            
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .listRowSeparator(.hidden)
            
        }
        .listStyle(.plain)
    }
    
    
    @ViewBuilder
    private func listRowView(for article: Articles) -> some View {

        ArticlesRowView(article: article)
            .onTapGesture {
                selectedArticleURL = article.articleURL
            }
    }
        
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: gridItems, spacing: gridSpacing) {
                ForEach(articles) { article in
                    if let nextPageHandler = nextPageHandler, article == articles.last {
                        gridItemView(for: article)
                            .task { await nextPageHandler() }
                    } else {
                        gridItemView(for: article)
                    }
                }
            }
            .padding()
            
            if isFetchingNextPage {
                bottomProgressView
            }
        }
        .background(Color(uiColor: .secondarySystemGroupedBackground))
    }
    
    @ViewBuilder
    private func gridItemView(for article: Articles) -> some View {

        ArticlesRowView(article: article)
            .onTapGesture { handleOnTapGesture(article: article) }
            .frame(height: 360)
            .background(Color(uiColor: .systemBackground))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 4)
            .padding(.bottom, 4)
    }
    
    private var gridItems: [GridItem] {
        [GridItem(.adaptive(minimum: 300), spacing: 8)]

    }
    
    private var gridSpacing: CGFloat? {
        nil
        
    }
    
    private func handleOnTapGesture(article: Articles) {
        self.selectedArticleURL = article.articleURL

    }
    
    @ViewBuilder
    private var rootView: some View {
            listView
        }
    }
    

extension URL: Identifiable {
    public var id: String { absoluteString }
    
}

struct ArticleListView_Previews: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            ArticleListView(articles: Articles.previewData)
        }
    }
}
