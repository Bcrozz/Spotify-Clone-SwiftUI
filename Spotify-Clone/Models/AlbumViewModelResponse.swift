//
//  AlbumResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 19/12/21.
//

import Foundation

class AlbumViewModelResponse: ObservableObject {
    
    @Published var viewModels = [AlbumCellViewModel]()
    
    func fetchData(with albumID: String){
        AuthManager.shared.withVaidToken { [weak self] token in
            APICaller.shared.provider.request(.getAlbumDetail(accessToken: token, id: albumID),callbackQueue: .main) { result in
                
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = AlbumsDetailResponse(JSON: jsonData){
                            self?.viewModels = model.tracks?.items.compactMap({
                                AlbumCellViewModel(name: $0.name, artistName: $0.artists?.first?.name ?? "")
                            }) ?? [AlbumCellViewModel]()
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
