//
//  ArtistResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 20/12/21.
//

import Foundation

enum ArtistResponseViewModel {
    case ArtistAlbum(albums : [Album],models: [ArtistAlbumCellViewModel])
    case AritstTopTracks(tracks : [AudioTrack],models: [ArtistTopTracksCellViewModel])
    case ArtistRelatedArtists(artists: [Artist],models: [ArtistRelatedCellViewModel])
}

class ArtistViewModelResponse: ObservableObject {
    
    @Published var artist: Artist?
    @Published var artistAlbum: [Album] = []
    @Published var artistTopTracks: [AudioTrack] = []
    @Published var artistRelatedArtists: [Artist] = []
    
    @Published var sections: [ArtistResponseViewModel] = []
    
    func fetchData(with artistID: String){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        var artistResponse: Artist?
        var artistTopTracksResponse: [AudioTrack]?
        var artistAlbumResponse: [Album]?
        var artistRelatedResponse: [Artist]?
        
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getArtist(accessToken: token, id: artistID)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = Artist(JSON: jsonData) {
                            artistResponse = model
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription,error.response?.statusCode)
                }
    
            }
        }
        
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getArtistTopTracks(accessToken: token, id: artistID)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = ArtistTopTracksResponse(JSON: jsonData) {
                            artistTopTracksResponse = model.tracks
                        }
                    }
                    catch {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription,error.response?.statusCode)
                }
    
            }
        }
        
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getArtistAlbums(accessToken: token, id: artistID, limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = ArtistAlbumsResponse(JSON: jsonData){
                            artistAlbumResponse = model.items
                        }
                    }
                    catch {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription,error.response?.statusCode)
                }
    
            }
        }
        
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getArtistRelateArtists(accessToken: token, id: artistID)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = ArtistRelatedArtistsResponse(JSON: jsonData) {
                            artistRelatedResponse = model.artists
                        }
                    }
                    catch {
                        
                    }
                case .failure(let error):
                    print(error.localizedDescription,error.response?.statusCode)
                }
    
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let artist = artistResponse,
                  let artistTopTracks = artistTopTracksResponse,
                  let artistAlbums = artistAlbumResponse,
                  let artistRelated = artistRelatedResponse else {
                      fatalError("Models are nil")
                  }
            print("Configureing artist viewModels")
            self?.configureModel(artist: artist, artistTopTracks: artistTopTracks, artistAlbum: artistAlbums, relatedArtists: artistRelated)
        }
    }
    
    private func configureModel(artist: Artist,artistTopTracks: [AudioTrack],artistAlbum: [Album], relatedArtists: [Artist]){
        self.artist = artist
        self.artistTopTracks = artistTopTracks
        self.artistAlbum = artistAlbum
        self.artistRelatedArtists = relatedArtists
        
        sections.append(.AritstTopTracks(tracks: artistTopTracks,models: artistTopTracks.compactMap({
            ArtistTopTracksCellViewModel(name: $0.name, trackNumber: $0.trackNumber, albumArtworkURL: URL(string: $0.album?.images?[2].url ?? ""))
        })))
        
        sections.append(.ArtistAlbum(albums: artistAlbum,models: artistAlbum.compactMap({
            ArtistAlbumCellViewModel(albumType: $0.albumType, releaseYear: $0.releaseData, name: $0.name, totalTracks: $0.totalTracks, artworkURL: URL(string: $0.images?[1].url ?? ""))
        })))
        
        sections.append(.ArtistRelatedArtists(artists: relatedArtists,models: relatedArtists.compactMap({
            ArtistRelatedCellViewModel(name: $0.name, artworkURL: URL(string: $0.images?.first?.url ?? ""))
        })))
        
    }

    
}
