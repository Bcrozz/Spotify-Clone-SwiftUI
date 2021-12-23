//
//  PlaylistView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 19/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct PlaylistView: View {
    
    @ObservedObject var featureAlbumResponse = PlaylistViewModelResponse()
    
    let data = Array(1...20).map {
        "Item \($0)"
    }
    
    let colume = [GridItem(.flexible())]
    
    let playlist: Playlist

    init(_ playlist: Playlist){
        self.playlist = playlist
        featureAlbumResponse.fetchData(with: playlist.id ?? "")
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            WebImage(url: URL(string: playlist.images?[0].url ?? ""))
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.70)
            HStack{
                GeometryReader { geometry in
                    VStack(alignment: .leading,spacing: 14){
                        Text(playlist.description ?? "")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: geometry.size.width,alignment: .leading)
                            .lineLimit(2)
                        Text(playlist.owner?.displayName ?? "")
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
                ForEach(featureAlbumResponse.viewModels, id: \.id){ viewModel in
                    HStack{
                        WebImage(url: viewModel.artworkURL)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                        Spacer()
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
                    }
                    .padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                    .frame(maxHeight: 55)
                }
            }
        }
        .padding(.bottom,20)
        .background(
            LinearGradient(gradient: Gradient(colors: [averrageColor(from: URL(string: playlist.images?[0].url ?? "")) ?? Color("almostlight"),Color("almostblack")]), startPoint: .top, endPoint: .bottom)
        )
        .navigationBarTitle(playlist.name ?? "",displayMode: .inline)
    }
    
    private func averrageColor(from url: URL?) -> Color?{
        let uiImageView = UIImageView()
        uiImageView.sd_setImage(with: url, completed: nil)
        print(uiImageView.image?.averageColor)
        guard let uiColorFromUIImage = uiImageView.image?.averageColor else {
            return nil
        }
        return Color(uiColorFromUIImage)
    }
    
}

//struct PlaylistView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaylistView()
//    }
//}
