//
//  SearchResultView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import SwiftUI

struct SearchResultView: View {
    
    @EnvironmentObject var searchResultResponse:SearchResultViewModelResponse
    
    var body: some View{
        ScrollView(showsIndicators: false){
            if searchResultResponse.sections.count > 0 {
                ForEach(0..<searchResultResponse.sections.count){ index in
                    switch searchResultResponse.sections[index] {
                    case .tracks(let models,let viewModels):
                        if viewModels.count > 0 {
                            SongSectionView(models,viewModels)
                        }
                    case .artists(let models,let viewModels):
                        if viewModels.count > 0 {
                            ArtistSectionView(models,viewModels)
                        }
                    case .albums(let models,let viewModels):
                        if viewModels.count > 0 {
                            AlbumSectionView(models,viewModels)
                        }
                    case .playlists(let models,let viewModels):
                        if viewModels.count > 0{
                            PlaylistSectionView(models,viewModels)
                        }
                    }
                }
            }
        }
        .background(Color("almostblack"))
    }
    
}

struct SearchResultView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
    }
}

struct SongSectionView: View {
    
    let rows = [
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10),
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10),
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10)
    ]
    
    let tracks: [AudioTrack]
    let viewModels: [UserTopTracksCellViewModel]
    
    init(_ tracks: [AudioTrack],_ viewModels: [UserTopTracksCellViewModel]){
        self.tracks = tracks
        self.viewModels = viewModels
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("Songs")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal,showsIndicators: false){
                LazyHGrid(rows: rows,spacing: 18){
                    ForEach(0..<viewModels.count){ index in
                        SongViewCell(viewModels[index])
                    }
                }
            }
        }
        .padding(.init(top: 0, leading: 18, bottom: 0, trailing: 0))
    }
    
}

struct ArtistSectionView: View {
    
    let row = [GridItem(.flexible(minimum: 190, maximum: 210))]
    
    let artists: [Artist]
    let viewModels: [UserTopArtistsCellViewModel]
    
    init(_ artists: [Artist],_ viewModels: [UserTopArtistsCellViewModel]){
        self.artists = artists
        self.viewModels = viewModels
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("Artists")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal,showsIndicators: false){
                LazyHGrid(rows: row, spacing: 0) {
                    ForEach(0..<viewModels.count) { index in
                        NavigationLink(destination: ArtistView(with: artists[index])) {
                            ArtistViewCell(viewModels[index])
                        }
                    }
                }
            }
        }
        .padding(.init(top: 40, leading: 18, bottom: 0, trailing: 0))
    }
}

struct AlbumSectionView: View {
    
    let row = [GridItem(.flexible(minimum: 210, maximum: 300))]
    
    let albums: [Album]
    let viewModels: [FeaturedPlaylistCellViewModel]
    
    init(_ albums: [Album],_ viewModels: [FeaturedPlaylistCellViewModel]){
        self.albums = albums
        self.viewModels = viewModels
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("Albums")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal,showsIndicators: false){
                LazyHGrid(rows: row, spacing: 10) {
                    ForEach(0..<viewModels.count) { index in
                        NavigationLink(destination: AlbumView(albums[index])) {
                            AlbumViewCell(viewModels[index],nil)
                        }
                    }
                }
            }
        }
        .padding(.init(top: 40, leading: 18, bottom: 0, trailing: 0))
    }
    
}

struct PlaylistSectionView: View {
    
    let row = [GridItem(.flexible(minimum: 210, maximum: 300))]
    
    let playlists: [Playlist]
    let viewModels: [FeaturedPlaylistCellViewModel]
    
    init(_ playlists: [Playlist],_ viewModels: [FeaturedPlaylistCellViewModel]){
        self.playlists = playlists
        self.viewModels = viewModels
    }
    
    var body: some View{
        VStack(alignment: .leading, spacing: 20) {
            Text("Playlists")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal,showsIndicators: false){
                LazyHGrid(rows: row, spacing: 10) {
                    ForEach(0..<20) { index in
                        NavigationLink(destination: PlaylistView(playlists[index])) {
                            AlbumViewCell(nil,viewModels[index])
                        }
                    }
                }
            }
        }
        .padding(.init(top: 40, leading: 18, bottom: 20, trailing: 0))
    }
}
