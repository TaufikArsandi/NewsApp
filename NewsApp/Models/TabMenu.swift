//
//  TabMenu.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import Foundation

enum TabMenu: String, CaseIterable {
    
    case news
    case search
    
    var text: String { rawValue.capitalized }
    var systemImage: String {
        switch self {
        case .news:     return "newspaper"
        case .search:   return "magnifyingglass"
        }
    }
    
    init(menuItem: MenuItem.ID?) {
        switch MenuItem(id: menuItem) {
        case .search:   self = .search
        default:
            self = .news
        }
    }
    
    func menuItemId(category: Category?) -> MenuItem.ID {
        switch self {
        case .news:     return MenuItem.category(category ?? .general).id
        case .search:   return MenuItem.search.id
        }
    }
}

extension TabMenu: Identifiable {
    
    var id: Self { self }
}
