//
//  Spotify_CloneApp.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 17/12/21.
//

import SwiftUI

@main
struct Spotify_CloneApp: App {
    var body: some Scene {
        WindowGroup {
            if AuthManager.shared.isSignedIn {
                TabbarView()
            }else {
                WelcomeView()
                    .edgesIgnoringSafeArea(.all)
                    .preferredColorScheme(.dark)
            }
        }
    }
    
}
