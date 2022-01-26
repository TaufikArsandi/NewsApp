//
//  NewsResponse.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import Foundation

struct NewsResponse: Decodable {
    
    let status: String
    let totalResults: Int?
    let articles: [Articles]
    
    let code: String?
    let message: String?
    
}
