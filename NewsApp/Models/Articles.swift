//
//  Articles.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import Foundation

fileprivate let relativeDateFormatter = RelativeDateTimeFormatter()

struct Articles {
    let id = UUID()
    
    let source: Source
    
    let title: String
    let url: String
    let publishedAt: Date
    
    let author: String?
    let description: String?
    let urlToImage: String?
    
    enum CodingKeys: String, CodingKey {
        case source
        case title
        case url
        case publishedAt
        case author
        case description
        case urlToImage
    }
    
    var authorText: String {
        author ?? ""
    }
    
    var descriptionText: String {
        description ?? ""
    }
    
    var captionText: String {
        "\(source.name) ‧ \(relativeDateFormatter.localizedString(for: publishedAt, relativeTo: Date()))"
    }
    
    var articleURL: URL {
        URL(string: url)!
    }
    
    var imageURL: URL? {
        guard let urlToImage = urlToImage else {
            return nil
        }
        return URL(string: urlToImage)
    }
    
}

extension Articles: Codable {}
extension Articles: Equatable {}
extension Articles: Identifiable {}

extension Articles {
    
    static var previewData: [Articles] {
        let previewDataURL = Bundle.main.url(forResource: "news", withExtension: "json")!
        let data = try! Data(contentsOf: previewDataURL)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        
        let apiResponse = try! jsonDecoder.decode(NewsResponse.self, from: data)
        return apiResponse.articles ?? []
    }
    
    static var previewCategoryArticles: [CategoryArticles] {
        let articles = previewData
        return Category.allCases.map {
            .init(category: $0, articles: articles.shuffled())
        }
    }
    
}

struct Source {
    let name: String
}

extension Source: Codable {}
extension Source: Equatable {}

