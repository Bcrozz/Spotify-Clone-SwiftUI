//
//  UserAlbumView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 22/12/21.
//

import SwiftUI

struct UserAlbumView: View {
    
    let colume = [GridItem(.flexible())]
    
    let playlists: [Playlist]?
    let albums: [Album]?
    let artists: [Artist]?
    let viewModels: [UserPlaylistCellViewModel]

    
    init(_ playlists: [Playlist]?,_ albums: [Album]?,_ artists: [Artist]?,_ viewModels: [UserPlaylistCellViewModel] = []){
        self.playlists = playlists
        self.albums = albums
        self.artists = artists
        self.viewModels = viewModels
    }
    
    var body: some View {
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
}


struct UserAlbumViewCell: View {
    var body: some View{
        Text("")
    }
}
