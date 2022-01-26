//
//  ContentView.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import SwiftUI

struct ContentView: View {
    
    @AppStorage("item_selection") var selectedMenuItemId: MenuItem.ID?
    
    var body: some View {
        TabContentView(selectedMenuItemId: $selectedMenuItemId)
    }
}
