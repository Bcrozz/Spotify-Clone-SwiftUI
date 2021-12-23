//
//  GenreView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct GenreView: View {
    
    let data = Array(1...20).map {
        "Item \($0)"
    }
    
    @ObservedObject var genreViewModelResponse = GenreViewModelResponse()
    
    let columes = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible())
    ]
    
    let genre: Category
    
    init(with genre: Category){
        self.genre = genre
        genreViewModelResponse.fetchData(with: genre.id ?? "")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            if genreViewModelResponse.playlistsViewModels.count > 0 {
                LazyVGrid(columns: columes,spacing: 20) {
                    ForEach(0..<genreViewModelResponse.playlistsViewModels.count){ index in
                        NavigationLink(destination: PlaylistView(genreViewModelResponse.playlists[index])) {
                            GenreViewCell(with: genreViewModelResponse.playlistsViewModels[index])
                        }
                    }
                }
                .padding(.init(top: 0, leading: 25, bottom: 20, trailing: 25))
            }
        }
        .background(Color("almostblack"))
        .navigationBarTitle(genre.name ?? "",displayMode: .inline)
    }
}


struct GenreViewCell: View {
    
    let viewModel: FeaturedPlaylistCellViewModel
    
    init(with viewModel: FeaturedPlaylistCellViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geo in
            VStack{
                WebImage(url: viewModel.artworkURL)
                    .resizable()
                    .aspectRatio(1.0, contentMode: .fit)
                Text(viewModel.name ?? "")
                    .font(.system(size: 15, weight: .semibold, design: .default))
                    .foregroundColor(.white)
                    .frame(width: geo.size.width * 0.9,height: 18)
                Text(viewModel.creatorName ?? "")
                    .font(.system(size: 13, weight: .regular, design: .default))
                    .foregroundColor(.white)
                    .frame(width: geo.size.width * 0.9,height: 15)
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.25)
    }
}
