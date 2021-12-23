//
//  NewReleaseAlbumViewCell.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct NewReleaseAlbumViewCell: View {
    
    let viewModel: NewReleasesCellViewModel
    
    init(with viewModel: NewReleasesCellViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(){
            WebImage(url: viewModel.artworkURL)
                .resizable()
                .aspectRatio(1,contentMode: .fit)
            VStack(alignment: .leading){
                Text(viewModel.name ?? "")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text(viewModel.artistName ?? "")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Text("Tracks: \(viewModel.numberOfTracks ?? 0)")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .frame(width: 190, alignment: .leading)
            .padding(.init(top: 5, leading: 0, bottom: 10, trailing: 0))
        }
    }
}

