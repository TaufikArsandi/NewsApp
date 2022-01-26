//
//  Category.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import Foundation

enum Category: String, CaseIterable, Codable {
    case general
    case business
    case technology
    case entertainment
    case sports
    case science
    case health
    
    var text: String {
        if self == .general {
            return "Top Headlines"
        }
        return rawValue.capitalized
    }
    
    var systemImage: String {
        switch self {
        case .general:          return "newspaper"
        case .business:         return "building.2"
        case .technology:       return "desktopcomputer"
        case .entertainment:    return "tv"
        case .sports:           return "sportscourt"
        case .science:          return "wave.3.right"
        case .health:           return "cross"
        }
    }
    
    var sortIndex: Int {
        Self.allCases.firstIndex(of: self) ?? 0
    }
}

extension Category: Identifiable {
    var id: Self { self }
}
