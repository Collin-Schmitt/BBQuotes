//
//  ContentView.swift
//  BBQuotes
//
//  Created by Collin Schmitt on 1/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            //in here we put our tabs
            Tab("Breaking Bad", systemImage: "tortoise"){
                QuoteView(show: "Breaking Bad")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            
            Tab("Better Call Saul", systemImage: "briefcase"){
                QuoteView(show: "Better Call Saul")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
