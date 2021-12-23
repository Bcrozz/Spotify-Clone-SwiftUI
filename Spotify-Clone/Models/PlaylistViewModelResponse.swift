//
//  PlaylistResponse.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 19/12/21.
//

import Foundation

class PlaylistViewModelResponse: ObservableObject {
    
    @Published var viewModels = [RecommendedTrackCellViewModel]()
    
    func fetchData(with playlistID: String){
        AuthManager.shared.withVaidToken { [weak self] token in
            APICaller.shared.provider.request(.getPlaylistDetail(accessToken: token, id: playlistID),callbackQueue: .main) { result in
                
                switch result {
                case .success(let response):
                    do{
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let model = PlaylistDetailResponse(JSON: jsonData){
                            self?.viewModels = model.tracksInList?.items.compactMap({
                                RecommendedTrackCellViewModel(name: $0.track?.name,
                                                              artistName: $0.track?.artists?.first?.name ?? "-",
                                                              artworkURL: URL(string: $0.track?.album?.images?.first?.url ?? ""))
                            }) ?? [RecommendedTrackCellViewModel]()
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
