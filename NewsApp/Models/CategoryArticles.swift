//
//  CategoryArticles.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import Foundation

struct CategoryArticles: Codable {
    
    let category: Category
    let articles: [Articles]
}
