//
//  SearchResultResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import Foundation

enum SearchResponse {
    case playlists(models: [Playlist],viewModels: [FeaturedPlaylistCellViewModel])
    case albums(models: [Album],viewModels: [FeaturedPlaylistCellViewModel])
    case tracks(models: [AudioTrack],viewModels: [UserTopTracksCellViewModel])
    case artists(models: [Artist],viewModels: [UserTopArtistsCellViewModel])
}

class SearchResultViewModelResponse: ObservableObject {
    
    static let shared = SearchResultViewModelResponse()
    
    @Published var sections: [SearchResponse] = []
    
    func fetchResultData(with query: String){
        AuthManager.shared.withVaidToken { [weak self] token in
            APICaller.shared.provider.request(.search(accessToken: token, query: query)) { result in
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let searchResult = SearchResultResponse(JSON: jsonData){
                            self?.configureModel(with: searchResult)
                        }
                    }
                    catch {

                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func configureModel(with searchResult: SearchResultResponse){
        sections = [
            .tracks(models: searchResult.tracks ?? [AudioTrack](),viewModels: searchResult.tracks?.compactMap({
                UserTopTracksCellViewModel(name: $0.name, artistName: $0.artists?.first?.name, artworkURL: URL(string: $0.album?.images?.first?.url ?? ""), albumName: $0.album?.name)
            }) ?? [UserTopTracksCellViewModel]()),
            .artists(models: searchResult.artists ?? [Artist](),viewModels: searchResult.artists?.compactMap({
                UserTopArtistsCellViewModel(name: $0.name, artworkURL: URL(string: $0.images?.first?.url ?? ""))
            }) ?? [UserTopArtistsCellViewModel]()),
            .albums(models: searchResult.albums ?? [Album](),viewModels: searchResult.albums?.compactMap({
                FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images?.first?.url ?? ""), creatorName: $0.artists?.first?.name)
            }) ?? [FeaturedPlaylistCellViewModel]()),
            .playlists(models: searchResult.playlists ?? [Playlist](),viewModels: searchResult.playlists?.compactMap({
                FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images?.first?.url ?? ""), creatorName: $0.owner?.displayName)
            }) ?? [FeaturedPlaylistCellViewModel]())
        ]
    }
    
}
