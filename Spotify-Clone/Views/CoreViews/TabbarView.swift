//
//  TabbarView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import SwiftUI

struct TabbarView: View {
    
    @Environment(\.isSearching) var isSearching
    
    init(){
        UITabBar.appearance().barTintColor = .black
        UITabBar.appearance().isTranslucent = true
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().tintColor = .white
        AuthManager.shared.refreshTokenIfNeeded(completion: nil)
    }
    
    @State var selectedIndex = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            SearchControlView()
                .tag(1)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            LibraryView()
                .tag(2)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Your Library")
                }
        }
        .background(Color("almostblack"))
        .preferredColorScheme(.dark)
    }
}

struct TabbarView_Previews: PreviewProvider {
    static var previews: some View {
        TabbarView()
    }
}
