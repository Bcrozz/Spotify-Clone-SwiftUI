//
//  GenreViewModelResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import Foundation

class GenreViewModelResponse: ObservableObject {
    
    @Published var playlists = [Playlist]()
    @Published var playlistsViewModels = [FeaturedPlaylistCellViewModel]()
    
    func fetchData(with genreID: String){
        AuthManager.shared.withVaidToken { [weak self] token in
            APICaller.shared.provider.request(.getCategoryPlaylist(accessToken: token, categoryID: genreID, limit: 50),callbackQueue: .main) { result in
                
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let playlist = CategoryPlaylistResponse(JSON: jsonData) {
                            self?.playlists = playlist.items ?? [Playlist]()
                            self?.playlistsViewModels = playlist.items?.compactMap({
                                FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images?.first?.url ?? ""), creatorName: $0.owner?.displayName)
                            }) ?? [FeaturedPlaylistCellViewModel]()
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
