//
//  MenuItem.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import Foundation

enum MenuItem: CaseIterable {
    
    case search
    case category(Category)
    case settings
    
    var text: String {
        switch self {
        case .search:                   return "Search"
        case .category(let category):   return category.text
        case .settings:                 return "Settings"
        }
    }
    
    var systemImage: String {
        switch self {
        case .search:                   return "magnifyingglass"
        case .category(let category):   return category.systemImage
        case .settings:                 return "gear"
        }
    }
    
    static var allCases: [MenuItem] {
        return [.search] + Category.menuItems
    }
}

extension MenuItem: Identifiable {
    
    var id: String {
        switch self {
        case .search:                   return "search"
        case .category(let category):   return category.rawValue
        case .settings:                 return "settings"
        }
    }
    
    init?(id: MenuItem.ID?) {
        switch id {
        case MenuItem.search.id:    self = .search
        case MenuItem.settings.id:  self = .settings
        default:
            if let id = id, let category = Category(rawValue: id) {
                self = .category(category)
            } else {
                return nil
            }
        }
    }
    
}


extension Category {
    static var menuItems: [MenuItem] {
        allCases.map { .category($0) }
    }
}
