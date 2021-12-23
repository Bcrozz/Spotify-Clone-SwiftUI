//
//  AlbumViewCell.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct AlbumViewCell: View {
    
    let albumViewModel: FeaturedPlaylistCellViewModel?
    let playlistViewModel: FeaturedPlaylistCellViewModel?
    
    init(_ albumViewModel: FeaturedPlaylistCellViewModel?,_ playlistViewModel: FeaturedPlaylistCellViewModel?){
        self.albumViewModel = albumViewModel
        self.playlistViewModel = playlistViewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                WebImage(url: (playlistViewModel == nil) ? albumViewModel?.artworkURL : playlistViewModel?.artworkURL)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                VStack(alignment: .leading,spacing: 8){
                    Text((playlistViewModel == nil) ? albumViewModel?.name ?? "" : playlistViewModel?.name ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: geo.size.width * 0.9, alignment: .leading)
                        .lineLimit(1)
                    Text((playlistViewModel == nil) ? albumViewModel?.creatorName ?? "" : playlistViewModel?.creatorName ?? "")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .frame(maxWidth: geo.size.width * 0.9, alignment: .leading)
                        .lineLimit(1)
                }
                .padding(.leading,13)
            }
        }
        .frame(width: 170)
    }
}

