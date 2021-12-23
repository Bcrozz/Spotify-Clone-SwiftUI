//
//  LibraryViewModelResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 22/12/21.
//

import Foundation

enum LibrarySectionType {
    case UserPlaylist(playlist: [Playlist],viewModels: [UserPlaylistCellViewModel])
    case UserAlbum(albums: [Album],viewModels: [UserPlaylistCellViewModel])
    case UserSavedArtist(artists: [Artist],viewModels: [UserPlaylistCellViewModel])
}

class LibraryViewModelResponse: ObservableObject {
    
    @Published var sections = [LibrarySectionType]()
    
    func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        
        var userPlaylists: UserPlaylistResponse?
        var userAlbums: UserAlbumSavedResponse?
        var userArtists: UserSavedArtistResponse?
        
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getUserPlaylist(accessToken: token, limit: 50),callbackQueue: .main) { result in
                
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = UserPlaylistResponse(JSON: jsonData) {
                            userPlaylists = model
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getUserAlbum(accessToken: token, limit: 50),callbackQueue: .main) { result in
                
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = UserAlbumSavedResponse(JSON: jsonData) {
                            userAlbums = model
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getUserArtist(accessToken: token, limit: 50), callbackQueue: .main) { result in
                
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = UserSavedArtistResponse(JSON: jsonData) {
                            userArtists = model
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let playlists = userPlaylists?.items,
                  let albums = userAlbums?.items,
                  let artists = userArtists?.items else {
                    fatalError("model library are nil")
                }
            print("Configureing library viewModels")
            self?.configureModel(userPlaylists: playlists,
                                 userAlbums: albums,
                                 userArtist: artists)
        }
        
    }
    
    private func configureModel(userPlaylists: [Playlist],
                                userAlbums: [UserAlbumDetail],
                                userArtist: [Artist]){
        
        sections.append(.UserPlaylist(playlist: userPlaylists, viewModels: userPlaylists.compactMap({
            UserPlaylistCellViewModel(name: $0.name, type: $0.type, owner: $0.owner?.displayName, artworkURL: URL(string: $0.images?.first?.url ?? ""))
        })))
        sections.append(.UserAlbum(albums: userAlbums.compactMap({
            $0.album
        }), viewModels: userAlbums.compactMap({
            UserPlaylistCellViewModel(name: $0.album?.name, type: $0.album?.albumType, owner: $0.album?.artists?.first?.name, artworkURL: URL(string: $0.album?.images?.first?.url ?? ""))
        })))
        sections.append(.UserSavedArtist(artists: userArtist, viewModels: userArtist.compactMap({
            UserPlaylistCellViewModel(name: $0.name, type: $0.type, owner: "", artworkURL: URL(string: $0.images?.first?.url ?? ""))
        })))
    }
    
}
