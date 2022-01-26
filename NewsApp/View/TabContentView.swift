//
//  TabContentView.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import SwiftUI

struct TabContentView: View {
    
    @Binding var selectedMenuItemId: MenuItem.ID?
    private var selection: Binding<TabMenu> {
        Binding {
            TabMenu(menuItem: selectedMenuItemId)
        } set: { newValue in
            selectedMenuItemId = newValue.menuItemId(category: selectedCategory ?? .general)
        }
    }
    
    private var selectedCategory: Category? {
        let menuItem = MenuItem(id: selectedMenuItemId)
        if case .category(let category) = menuItem {
            return category
        } else {
            return nil
        }
    }
    
    var body: some View {
        TabView(selection: selection) {
            ForEach(TabMenu.allCases) { item in
                NavigationView {
                    viewForTabItem(item)
                }
                .tabItem {
                    Label(item.text, systemImage: item.systemImage)
                }
                .tag(item)
            }
        }
    }
    
    @ViewBuilder
    private func viewForTabItem(_ item: TabMenu) -> some View {
        switch item {
        case .news:
            NewsTabView(category: selectedCategory ?? .general)
        case .search:
            SearchTabView()
        }
    }
}

struct TabContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabContentView(selectedMenuItemId: .constant(nil))
    }
}
