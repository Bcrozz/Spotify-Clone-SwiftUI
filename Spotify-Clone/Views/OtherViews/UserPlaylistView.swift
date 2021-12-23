//
//  UserPlaylistView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 22/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserPlaylistView: View {
    
    let colume = [GridItem(.flexible())]
    
    let playlists: [Playlist]?
    let albums: [Album]?
    let artists: [Artist]?
    var viewModels: [UserPlaylistCellViewModel] = []
    
    init(_ playlists: [Playlist]?,_ albums: [Album]?,_ artists: [Artist]?,_ viewModels: [UserPlaylistCellViewModel] = []){
        self.playlists = playlists
        self.albums = albums
        self.artists = artists
        self.viewModels = viewModels
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            LazyVGrid(columns: colume, spacing: 15) {
                ForEach(0..<viewModels.count) { index in
                    if playlists != nil{
                        NavigationLink(destination: PlaylistView(playlists![index])){
                            UserPlaylistViewCell(false,viewModels[index])
                        }
                    }
                    else if albums != nil {
                        NavigationLink(destination: AlbumView(albums![index])){
                            UserPlaylistViewCell(false,viewModels[index])
                        }
                    }
                    else if artists != nil {
                        NavigationLink(destination: ArtistView(with: artists![index])){
                            UserPlaylistViewCell(true,viewModels[index])
                        }
                    }
                    else {
                        
                    }
                }
            }
        }
        .padding(.init(top: 20, leading: 10, bottom: 0, trailing: 10))
        .background(Color("almostblack"))
    }
}


struct UserPlaylistViewCell: View {
    
    let shouldClipImage: Bool
    let viewModel: UserPlaylistCellViewModel
    
    init(_ shouldClipImage: Bool,_ viewModel: UserPlaylistCellViewModel){
        self.shouldClipImage = shouldClipImage
        self.viewModel = viewModel
    }
    
    var body: some View{
        GeometryReader{ geo in
            HStack(spacing: 10){
                if shouldClipImage {
                    WebImage(url: viewModel.artworkURL)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(Circle())
                }else {
                    WebImage(url: viewModel.artworkURL)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                }
                VStack(alignment: .leading,spacing: 3){
                    Text(viewModel.name ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: geo.size.width * 0.70,alignment: .leading)
                        .lineLimit(1)
                    if viewModel.owner != "" {
                        Text(viewModel.owner ?? "")
                            .font(.subheadline)
                            .fontWeight(.regular)
                            .foregroundColor(.gray.opacity(0.75))
                            .frame(maxWidth: geo.size.width * 0.70,alignment: .leading)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
        .frame(height: 65)
    }
}

