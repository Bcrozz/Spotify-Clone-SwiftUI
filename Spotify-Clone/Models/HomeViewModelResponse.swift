//
//  HomeViewModelResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import Foundation

enum BrowseSectionType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTrack(viewModels: [RecommendedTrackCellViewModel])
    case userTopTracks(viewModels: [UserTopTracksCellViewModel])
    case userTopArtists(viewModels: [UserTopArtistsCellViewModel])
    
    var title: String {
        switch self {
        case .newReleases:
            return "New releases"
        case .featuredPlaylists:
            return "Feature albums"
        case .recommendedTrack:
            return "Recommendation tracks"
        case .userTopTracks:
            return "Your top tracks"
        case .userTopArtists:
            return "Your top artists"
        }
    }
}

class HomeViewModelResponse: ObservableObject {
    
    @Published var newAlbumReleases: [Album] = []
    @Published var featurePlaylists: [Playlist] = []
    @Published var recommendationTracks: [AudioTrack] = []
    @Published var userTopArtists: [Artist] = []
    @Published var userTopTracks: [AudioTrack] = []
    
    @Published var sections = [BrowseSectionType]()
    
    private func randomSeed(genres: [String]?) -> Set<String>? {
        guard let genres = genres else {
            return nil
        }
        var seeds = Set<String>()
        while seeds.count < 5 {
            if let random = genres.randomElement() {
                seeds.insert(random)
            }
        }
        return seeds
    }
    
    func fetchData(){
        let group = DispatchGroup()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        group.enter()
        
        var newReleases: NewReleasesResponse?
        var playlistFeture: FeaturedPlaylists?
        var recommentResponse: RecommendationResponse?
        var topTracksResponse: UserTopTracksResponse?
        var topArtistsResponse: UserTopArtistsResponse?
        // new release list of album
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getNewReleases(accessToken: token,
                                                              limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = NewReleasesResponse.init(JSON: jsonData) {
                            newReleases = model
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
        //Featured playlists list of playlist
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getFeaturedPlaylists(accessToken: token,
                                                                    limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = FeaturedPlaylists.init(JSON: jsonData) {
                            playlistFeture = model
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
        //Recommend track list of track
        AuthManager.shared.withVaidToken { [weak self] token in
            APICaller.shared.provider.request(.getRecommendationGenres(accessToken: token)) { result in
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let recomGeres = RecommendationGenres(JSON: jsonData) {
                            let seeds = self?.randomSeed(genres: recomGeres.genres)
                            APICaller.shared.provider.request(.getRecommendations(accessToken: token,
                                                                                  seedGenre: seeds!,limit: 50)) { result in
                                defer {
                                    group.leave()
                                }
                                switch result {
                                case .success(let response):
                                    do{
                                        let jsonData = try response.mapJSON() as! [String: Any]
                                        if let model = RecommendationResponse.init(JSON: jsonData){
                                            recommentResponse = model
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
                    catch {
                        print(error.localizedDescription)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        //TopTracks
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getUserTopTracks(accessToken: token, limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = UserTopTracksResponse.init(JSON: jsonData) {
                            topTracksResponse = model
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
        //TopArtist
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getUserTopArtist(accessToken: token, limit: 50)) { result in
                defer {
                    group.leave()
                }
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = UserTopArtistsResponse.init(JSON: jsonData) {
                            topArtistsResponse = model
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
        
        group.notify(queue: .main){ [weak self] in
            guard let releases = newReleases?.albumsResponse?.items,
                  let playlists = playlistFeture?.playlists?.items,
                  let tracks = recommentResponse?.tracks,
                  let topTracks = topTracksResponse?.items,
                  let topArtists = topArtistsResponse?.items else {
                        fatalError("Models are nil")
                    }
            print("Configureing viewModels")
            self?.configureModel(newAlbums: releases,
                                playlists: playlists,
                                tracks: tracks,
                                topTracks: topTracks,
                                topArtists: topArtists)
        }
        
    }
    
    private func configureModel(newAlbums: [Album],
                                playlists: [Playlist],
                                tracks: [AudioTrack],
                                topTracks: [AudioTrack],
                                topArtists: [Artist]){
        self.newAlbumReleases = newAlbums
        self.featurePlaylists = playlists
        self.recommendationTracks = tracks
        self.userTopTracks = topTracks
        self.userTopArtists = topArtists
        
        sections.append(.newReleases(viewModels: newAlbums.compactMap({
            NewReleasesCellViewModel(name: $0.name,
                                     artworkURL: URL(string: $0.images?.first?.url ?? ""),
                                     numberOfTracks: $0.totalTracks,
                                     artistName: $0.artists?.first?.name ?? "-")
        })))
        sections.append(.featuredPlaylists(viewModels: playlists.compactMap({
            FeaturedPlaylistCellViewModel(name: $0.name,
                                          artworkURL: URL(string: $0.images?.first?.url ?? ""),
                                          creatorName: $0.owner?.displayName ?? "-")
        })))
        sections.append(.recommendedTrack(viewModels: tracks.compactMap({
            RecommendedTrackCellViewModel(name: $0.name,
                                          artistName: $0.artists?.first?.name ?? "-",
                                          artworkURL: URL(string: $0.album?.images?.first?.url ?? ""))
        })))
        sections.append(.userTopArtists(viewModels: topArtists.compactMap({
            UserTopArtistsCellViewModel(name: $0.name,
                                        artworkURL: URL(string: $0.images?.first?.url ?? ""))
        })))
        sections.append(.userTopTracks(viewModels: topTracks.compactMap({
            UserTopTracksCellViewModel(name: $0.name,
                                       artistName: $0.artists?.first?.name ?? "-",
                                       artworkURL: URL(string: $0.album?.images?[1].url ?? ""),
                                       albumName: $0.album?.name ?? "-")
        })))
    }
    
}
