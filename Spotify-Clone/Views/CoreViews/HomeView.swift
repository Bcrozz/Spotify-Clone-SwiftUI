//
//  HomeView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import SwiftUI

struct HomeView: View {

    @ObservedObject var responseFromAPI = HomeViewModelResponse()
    @State private var presentSetting: Int? = 0
    
    init(){
        responseFromAPI.fetchData()
    }
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                if responseFromAPI.sections.count > 0{
                    ForEach(0..<5){ num in
                        switch responseFromAPI.sections[num] {
                        case .newReleases(let viewModels):
                            NewReleases(with: viewModels,responseFromAPI.newAlbumReleases)
                        case .featuredPlaylists(let viewModels):
                            FeatureAlbums(minHeight: 230, maxHeight: 260,header: "Feature albums",shouldClipImage: false,with: viewModels,with: nil,responseFromAPI.featurePlaylists,nil)
                        case .recommendedTrack(let viewModels):
                            RecommendationTracks(bottom: 0,header: "Recommendation tracks",isTopTracks: false,with: viewModels,with: nil)
                        case .userTopTracks(let viewModels):
                            RecommendationTracks(bottom: 40,header:"Your top tracks",isTopTracks: true,with: nil,with: viewModels)
                                .padding(.bottom,20)
                        case .userTopArtists(let viewModels):
                            FeatureAlbums(minHeight: 180, maxHeight: 210, header: "Your top artists",shouldClipImage: true,with: nil,with: viewModels,nil,responseFromAPI.userTopArtists)
                        }
                    }
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color("darkgray"),Color("almostblack")]), startPoint: .top, endPoint: .bottom)
            )
            .toolbar{
                Button{
                    presentSetting = 10
                } label: {
                    NavigationLink(tag: 10, selection: $presentSetting) {
                        SettingView()
                    } label: {
                        Image(systemName: "gear")
                    }

                }
            }
            .navigationBarTitle("Browse",displayMode: .inline)
        }
    }
    
    
}


private struct NewReleases: View {
    
    let newReleasesAlbum: [Album]
    let viewModels: [NewReleasesCellViewModel]
    
    let newReleasesLayout = [
        GridItem(.flexible(minimum: 125, maximum: 150),spacing: 18),
        GridItem(.flexible(minimum: 125, maximum: 150),spacing: 18)
    ]
    
    init(with viewModels: [NewReleasesCellViewModel],_ albums: [Album]){
        self.viewModels = viewModels
        self.newReleasesAlbum = albums
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing: 20){
            Text("New releases")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal,showsIndicators: false) {
                LazyHGrid(rows: newReleasesLayout,spacing: 18) {
                    ForEach(0..<viewModels.count) { index in
                        NavigationLink(destination: AlbumView(newReleasesAlbum[index])) {
                            NewReleaseAlbumViewCell(with: viewModels[index])
                                .frame(minWidth: UIScreen.main.bounds.width * 0.8,minHeight: 125,maxHeight: 140,alignment: .leading)
                                .background(.gray.opacity(0.20))
                        }
                    }
                }
            }
        }
        .padding(.init(top: 18, leading: 18, bottom: 0, trailing: 0))
    }

}

private struct FeatureAlbums: View{
    
    let layout: [GridItem]
    let maxHeight: CGFloat
    let minHeight: CGFloat
    let header: String
    let shouldClipImage: Bool
    let featureAlbumViewModels: [FeaturedPlaylistCellViewModel]?
    let userTopArtistsViewModels: [UserTopArtistsCellViewModel]?
    let featurePlaylists: [Playlist]?
    let userTopArtists: [Artist]?
    
    init(minHeight: CGFloat,maxHeight: CGFloat,header: String,shouldClipImage: Bool,with FAViewModels: [FeaturedPlaylistCellViewModel]?,with UTAViewModels:[UserTopArtistsCellViewModel]?,_ featurePlaylists: [Playlist]?,_ userTopArtists: [Artist]?){
        layout = [
            GridItem(.flexible(minimum: minHeight, maximum: maxHeight))
        ]
        self.maxHeight = maxHeight
        self.minHeight = minHeight
        self.header = header
        self.shouldClipImage = shouldClipImage
        featureAlbumViewModels = FAViewModels
        userTopArtistsViewModels = UTAViewModels
        self.featurePlaylists = featurePlaylists
        self.userTopArtists = userTopArtists
    }
    
    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            Text(header)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: layout, spacing: 18) {
                    if featureAlbumViewModels != nil && featurePlaylists != nil {
                        ForEach(0..<featureAlbumViewModels!.count) { index in
                            NavigationLink(destination: PlaylistView(featurePlaylists![index])) {
                                FeatureAlbumsViewCell(shouldClipImage,with: featureAlbumViewModels![index],with: nil)
                                .frame(minWidth: (UIScreen.main.bounds.width * 0.8)/2.0,minHeight: minHeight,maxHeight: maxHeight)
                            }
                        }
                    }
                    if userTopArtistsViewModels != nil && userTopArtists != nil {
                        ForEach(0..<userTopArtistsViewModels!.count) { index in
                            NavigationLink(destination: ArtistView(with: userTopArtists![index])){
                                FeatureAlbumsViewCell(shouldClipImage,with: nil,with: userTopArtistsViewModels![index])
                                .frame(minWidth: (UIScreen.main.bounds.width * 0.8)/2.0,minHeight: minHeight,maxHeight: maxHeight)
                            }
                        }
                    }
                }
            }
        }
        .padding(.init(top: 40, leading: 18, bottom: 0, trailing: 0))
    }
}

private struct RecommendationTracks: View{
    
    let newReleasesLayout = [
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10),
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10),
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10)
    ]
    let bottom: CGFloat
    let header: String
    let isTopTracks: Bool
    let recommendationTrackViewModels: [RecommendedTrackCellViewModel]?
    let userTopTrackViewModels: [UserTopTracksCellViewModel]?
    
    init(bottom: CGFloat,header: String,isTopTracks: Bool,with RCTViewModels: [RecommendedTrackCellViewModel]?,with UTTViewModels:[UserTopTracksCellViewModel]?){
        self.bottom = bottom
        self.header = header
        self.isTopTracks = isTopTracks
        recommendationTrackViewModels = RCTViewModels
        userTopTrackViewModels = UTTViewModels
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing: 20){
            Text(header)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal,showsIndicators: false) {
                LazyHGrid(rows: newReleasesLayout,spacing: 18) {
                    if recommendationTrackViewModels != nil {
                        ForEach(recommendationTrackViewModels!, id: \.id) { viewModel in
                            RecommendationTracksViewCell(isTopTracks,viewModel,nil)
                        }
                    }
                    if userTopTrackViewModels != nil {
                        ForEach(userTopTrackViewModels!, id: \.id) { viewModel in
                            RecommendationTracksViewCell(isTopTracks,nil,viewModel)
                        }
                    }
                }
            }
        }
        .padding(.init(top: 40, leading: 18, bottom: 0, trailing: 0))
    }
}
