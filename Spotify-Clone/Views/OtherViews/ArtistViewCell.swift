//
//  ArtistViewCell.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtistViewCell: View {
    
    let viewModel: UserTopArtistsCellViewModel
    
    init(_ viewModel: UserTopArtistsCellViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                WebImage(url: viewModel.artworkURL)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(Circle())
                Text(viewModel.name ?? "")
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: geo.size.width * 0.85,alignment: .center)
                    .lineLimit(1)
            }
        }
        .frame(width: 180)
    }
}

