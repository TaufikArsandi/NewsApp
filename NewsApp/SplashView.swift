//
//  SplashView.swift
//  NewsApp
//
//  Created by Taufik Arsandi on 26/01/22.
//

import SwiftUI

struct SplashView: View {
    
    @State var isActive:Bool = false
    
    var body: some View {
        VStack {
            if self.isActive {
                ContentView()
            } else {
                Text("Welcome to NewsApp")
                    .padding()
                    .font(Font.largeTitle)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
    
}
