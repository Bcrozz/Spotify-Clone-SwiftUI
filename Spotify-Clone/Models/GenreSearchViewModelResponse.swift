//
//  GenresResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import Foundation

class GenreSearchViewModelResponse: ObservableObject {
    
    @Published var categories: [Category] = []
    @Published var categoriesViewModel: [CategoryCollectionViewCellViewModel] = []
    
    func fetchData(){
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getCategory(accessToken: token, limit: 50), callbackQueue: .main) { [weak self] result in
                
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let categories = CategoryResponse(JSON: jsonData) {
                            self?.categories = categories.items ?? [Category]()
                            self?.categoriesViewModel = categories.items?.compactMap({
                                CategoryCollectionViewCellViewModel(title: $0.name, artworkURL: URL(string: $0.icons?.first?.url ?? ""))
                            }) ?? [CategoryCollectionViewCellViewModel]()
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
