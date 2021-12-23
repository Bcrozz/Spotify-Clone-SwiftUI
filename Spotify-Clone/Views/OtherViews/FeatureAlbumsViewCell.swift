//
//  FeatureAlbumsViewCell.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct FeatureAlbumsViewCell: View {
    
    let shouldClipImage: Bool
    let featureAlbumViewModel: FeaturedPlaylistCellViewModel?
    let userTopArtistViewModel: UserTopArtistsCellViewModel?
    
    init(_ shouldClipImage: Bool,with featureAlbumViewModel: FeaturedPlaylistCellViewModel?,with userTopArtistViewModel: UserTopArtistsCellViewModel?){
        self.shouldClipImage = shouldClipImage
        self.featureAlbumViewModel = featureAlbumViewModel
        self.userTopArtistViewModel = userTopArtistViewModel
    }
    
    var body: some View {
        VStack(alignment: .leading){
            if shouldClipImage {
                WebImage(url: userTopArtistViewModel?.artworkURL)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(Circle())
                Text(userTopArtistViewModel?.name ?? "")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: 180,alignment: .center)
                    .lineLimit(1)
            }else {
                WebImage(url: featureAlbumViewModel?.artworkURL)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                VStack(alignment: .leading,spacing: 8){
                    Text(featureAlbumViewModel?.name ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: 180, alignment: .leading)
                        .lineLimit(1)
                    Text(featureAlbumViewModel?.creatorName ?? "")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .frame(maxWidth: 180, alignment: .leading)
                        .lineLimit(1)
                }
                .frame(maxWidth: 200, alignment: .leading)
                .padding(.init(top: 0, leading: 10, bottom: 10, trailing: 0))
            }
        }
    }
}


