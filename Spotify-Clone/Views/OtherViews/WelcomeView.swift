//
//  WelcomeView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import Foundation
import SwiftUI

struct WelcomeView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let welcomeVC = UINavigationController(rootViewController: WelcomeViewController(nibName: "WelcomeViewController", bundle: nil))
        return welcomeVC
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        
    }
    
    
    
}
