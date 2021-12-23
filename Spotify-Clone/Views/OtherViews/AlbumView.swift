//
//  AlbumView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 19/12/21.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct AlbumView: View {
    
    @ObservedObject var albumResponse = AlbumViewModelResponse()
    
    let data = Array(1...20).map {
        "Item \($0)"
    }
    
    let colume = [GridItem(.flexible())]
    
    let album: Album

    init(_ album: Album){
        self.album = album
        albumResponse.fetchData(with: album.id ?? "")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false){
            if albumResponse.viewModels.count > 0 {
                WebImage(url: URL(string: album.images?[0].url ?? ""))
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: UIScreen.main.bounds.width * 0.70)
                HStack{
                    GeometryReader { geometry in
                        VStack(alignment: .leading,spacing: 14){
                            Text(album.name ?? "")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: geometry.size.width,alignment: .leading)
                                .lineLimit(2)
                            Text(album.artists?[0].name ?? "")
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .frame(maxWidth: geometry.size.width,alignment: .leading)
                        }
                        .padding(.top,20)
                    }
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.green)
                        .padding(.top,30)
                }
                .frame(maxHeight: 90)
                .padding(.init(top: 0, leading: 25, bottom: 0, trailing: 20))
                Spacer()
                    .frame(height: 50)
                LazyVGrid(columns: colume,spacing: 15) {
                    ForEach(albumResponse.viewModels, id: \.id){ viewModel in
                        VStack(alignment: .leading,spacing: 3){
                            Text(viewModel.name ?? "")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: UIScreen.main.bounds.width,alignment: .leading)
                                .lineLimit(1)
                            Text(viewModel.artistName ?? "")
                                .font(.callout)
                                .fontWeight(.regular)
                                .foregroundColor(.white)
                                .frame(maxWidth: UIScreen.main.bounds.width,alignment: .leading)
                                .lineLimit(1)
                        }
                        .frame(maxWidth: UIScreen.main.bounds.width)
                        .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 15))
                    }
                }
            }
        }
        .padding(.bottom,20)
        .background(
            LinearGradient(gradient: Gradient(colors: [averrageColor(from: URL(string: album.images?[0].url ?? "")) ?? Color("almostlight"),Color("almostblack")]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarTitle(album.name ?? "",displayMode: .inline)
    }
    
    private func averrageColor(from url: URL?) -> Color?{
        let uiImageView = UIImageView()
        uiImageView.sd_setImage(with: url, completed: nil)
        guard let uiColorFromUIImage = uiImageView.image?.averageColor else {
            return nil
        }
        return Color(uiColorFromUIImage)
    }
    
}

