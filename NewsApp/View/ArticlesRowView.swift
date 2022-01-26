//
//  ArticlesRowView.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import SwiftUI

struct ArticlesRowView: View {
    
    let article: Articles
    
    var body: some View {
        contentView()
    }
    
    @ViewBuilder
    private func contentView(proxy: GeometryProxy? = nil) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            asyncImage
            
            VStack(alignment: .leading, spacing: 0) {
                Text(article.title)
                    .padding(.bottom, 8)
                    .font(.headline)
                    .lineLimit(3)
                
                Text(article.descriptionText)
                    .font(.subheadline)
                    .lineLimit(2)
                
                Spacer()
            
                HStack {
                    Text(article.captionText)
                        .lineLimit(1)
                        .foregroundColor(.secondary)
                        .font(.caption)
                    
                    Spacer()
                    
                }
                .buttonStyle(.bordered)
                
            }
            .padding([.horizontal, .bottom])
        }
    }
    
    private func shareButton(proxy: GeometryProxy?) -> some View {
        Button {
            presentShareSheet(url: article.articleURL, proxy: proxy)
        } label: {
            Image(systemName: "square.and.arrow.up")
        }
    }
    
    private var asyncImage: some View  {
        AsyncImage(url: article.imageURL) { phase in
            switch phase {
            case .empty:
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
            case .failure:
                HStack {
                    Spacer()
                    Image(systemName: "photo")
                        .imageScale(.large)
                    Spacer()
                }
                
                
            @unknown default:
                fatalError()
            }
        }
        
        .asyncImageFrame(horizontalSizeClass: .compact)
        .background(Color.gray.opacity(0.6))
        .clipped()
    }
}

extension View {
    
    func presentShareSheet(url: URL, proxy: GeometryProxy? = nil) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        guard let rootVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
            .keyWindow?
            .rootViewController else { return }
        
        activityVC.popoverPresentationController?.sourceView = rootVC.view
        if let proxy = proxy {
            activityVC.popoverPresentationController?.sourceRect = proxy.frame(in: .global)
        }
        rootVC.present(activityVC, animated: true)
    }
    
}

fileprivate extension View {
    
    @ViewBuilder
    func asyncImageFrame(horizontalSizeClass: UserInterfaceSizeClass) -> some View {
        switch horizontalSizeClass {
        case .regular:
            frame(height: 180)
        default:
            frame(minHeight: 200, maxHeight: 300)
        }
    }
    
}

struct ArticleRowView_Previews: PreviewProvider {

    static var previews: some View {
        NavigationView {
            List {
                ArticlesRowView(article: .previewData[0])
                    .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
        }
    }
}

