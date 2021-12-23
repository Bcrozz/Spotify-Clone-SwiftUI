//
//  ProfileViewModelResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 23/12/21.
//

import Foundation

class ProfileViewModelResponse: ObservableObject {
    
    @Published var userProfile: [UserProfile] = []
    
    func getCurrentUserProfile(){
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getCurrentUserProfile(accessToken: token),callbackQueue: .main) { [weak self] result in
                
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let profile = UserProfile.init(JSON: jsonData) {
                            self?.userProfile.append(profile)
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
