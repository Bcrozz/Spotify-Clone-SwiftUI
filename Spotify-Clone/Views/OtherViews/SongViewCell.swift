//
//  SongViewCell.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct SongViewCell: View {
    
    let viewModel: UserTopTracksCellViewModel
    
    init(_ viewModel: UserTopTracksCellViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader{ geo in
            HStack{
                WebImage(url: viewModel.artworkURL)
                    .resizable()
                    .aspectRatio(1,contentMode: .fit)
                VStack(alignment: .leading){
                    Text(viewModel.name ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(viewModel.artistName ?? "")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    Spacer()
                    Text(viewModel.albumName ?? "")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                }
                .frame(width: geo.size.width * 0.6,alignment: .leading)
                .padding(.init(top: 3, leading: 0, bottom: 3, trailing: 0))
            }
        }
        .frame(minWidth: UIScreen.main.bounds.width * 0.8,minHeight: 100,maxHeight: 120,alignment: .leading)
        .background(.gray.opacity(0.15))
    }
}

