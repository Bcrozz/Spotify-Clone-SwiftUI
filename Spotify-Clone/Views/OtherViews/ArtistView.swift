//
//  ArtistView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 19/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArtistView: View {
    
    @ObservedObject var artistResponse = ArtistViewModelResponse()
    
    let artist: Artist
    
    init(with artist:Artist){
        self.artist = artist
        artistResponse.fetchData(with: artist.id ?? "")
    }
    
    var body: some View {
        if artistResponse.sections.count > 0 {
            ScrollView(showsIndicators: false) {
                ZStack(alignment: .bottom){
                    WebImage(url: URL(string: artistResponse.artist?.images?[0].url ?? ""))
                        .resizable()
                        .aspectRatio(1.3, contentMode: .fit)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                    Text(artistResponse.artist?.name ?? "")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width * 0.9,alignment: .leading)
                        .lineLimit(1)
                        .padding(.init(top: 0, leading: 10, bottom: 10, trailing: 0))
                }
                HStack{
                    Text("Follow")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(width: 80, height: 30, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.white, lineWidth: 2)
                        )
                    Spacer()
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .foregroundColor(.green)
                        .padding(.top,22)
                }
                .padding(.init(top: 0, leading: 20, bottom: 0, trailing: 20))
                .frame(maxHeight: 90)
                HStack{
                    Text("Popular")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.init(top: 5, leading: 22, bottom: 0, trailing: 0))
                    Spacer()
                }
                ForEach(0..<3){ num in
                    switch artistResponse.sections[num]{
                    case .AritstTopTracks(let topTracks,let viewModels):
                        ArtistTopTrackView(topTracks,viewModels)
                    case .ArtistAlbum(let albums,let viewModels):
                        ArtistAlbumsView(albums,viewModels)
                    case .ArtistRelatedArtists(let artists,let viewModels):
                        RelateArtistsView(artists,viewModels)
                    }
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [averrageColor(from: URL(string: artist.images?[0].url ?? "")) ?? Color("almostlight"),Color("almostblack")]), startPoint: .top, endPoint: .bottom))
            .navigationBarTitle(artist.name ?? "",displayMode: .inline)
        }
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


struct ArtistTopTrackView: View {
    
    let data = Array(1...20).map {
        "Item \($0)"
    }
    
    let columes = [GridItem(.flexible())]
    
    let topTracks: [AudioTrack]
    let topTracksViewModels: [ArtistTopTracksCellViewModel]
    
    init(_ topTracks: [AudioTrack],_ topTracksViewModels: [ArtistTopTracksCellViewModel]){
        self.topTracks = topTracks
        self.topTracksViewModels = topTracksViewModels
    }
    
    var body: some View{
        LazyVGrid(columns: columes,spacing: 16) {
            ForEach(0..<topTracksViewModels.count){ index in
                HStack{
                    Text("\(index + 1)")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .frame(maxWidth: 15,alignment: .leading)
                        .lineLimit(1)
                        .padding(.init(top: 0, leading: 10, bottom: 0, trailing: 0))
                    WebImage(url: topTracksViewModels[index].albumArtworkURL)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                    Text(topTracksViewModels[index].name ?? "")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: 230,alignment: .leading)
                        .lineLimit(1)
                        .padding(.leading,5)
                    Spacer()
                }
                .padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                .frame(maxHeight: 50)
            }
        }
    }
    
}

struct ArtistAlbumsView: View {
    
    let data = Array(1...20).map {
        "Item \($0)"
    }
    
    let albumsLayout = [
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10),
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10),
        GridItem(.flexible(minimum: 100, maximum: 120),spacing: 10)
    ]
    
    let albums: [Album]
    let albumsViewModels: [ArtistAlbumCellViewModel]
    
    init(_ albums: [Album],_ albumsViewModels: [ArtistAlbumCellViewModel]){
        self.albums = albums
        self.albumsViewModels = albumsViewModels
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing: 20){
            Text("Albums")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal,showsIndicators: false) {
                LazyHGrid(rows: albumsLayout,spacing: 18) {
                    ForEach(0..<albumsViewModels.count) { index in
                        NavigationLink(destination: AlbumView(albums[index])) {
                            HStack{
                                WebImage(url: albumsViewModels[index].artworkURL)
                                    .resizable()
                                    .aspectRatio(1,contentMode: .fit)
                                VStack(alignment: .leading){
                                    Text(albumsViewModels[index].name ?? "")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                    Text(albumsViewModels[index].releaseYear ?? "")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.white)
                                }
                                .frame(width: 200,alignment: .leading)
                                .padding(.init(top: 3, leading: 0, bottom: 3, trailing: 0))
                            }
                            .frame(minWidth: UIScreen.main.bounds.width * 0.8,minHeight: 100,maxHeight: 120,alignment: .leading)
                            .background(.gray.opacity(0.15))
                        }
                    }
                }
            }
        }
        .padding(.init(top: 30, leading: 25, bottom: 0, trailing: 0))
    }
    
}

struct RelateArtistsView: View {
    
    let data = Array(1...20).map {
        "Item \($0)"
    }
    
    let layout = [
        GridItem(.flexible(minimum: 170, maximum: 200))
    ]
    
    let artists: [Artist]
    let artistsViewModel: [ArtistRelatedCellViewModel]
    
    init(_ artists: [Artist],_ artistsViewModel: [ArtistRelatedCellViewModel]){
        self.artists = artists
        self.artistsViewModel = artistsViewModel
    }
    
    var body: some View {
        VStack(alignment:.leading,spacing: 20){
            Text("Related artists")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
            ScrollView(.horizontal,showsIndicators: false){
                LazyHGrid(rows: layout, spacing: 18){
                    ForEach(0..<artistsViewModel.count) { index in
                        NavigationLink(destination: ArtistView(with: artists[index])) {
                            VStack(alignment: .leading){
                                WebImage(url: artistsViewModel[index].artworkURL)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .clipShape(Circle())
                                Text(artistsViewModel[index].name ?? "")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 170,alignment: .center)
                                    .lineLimit(1)
                            }
                            .frame(minWidth: (UIScreen.main.bounds.width * 0.8)/2.0,minHeight: 170,maxHeight: 200)
                        }
                    }
                }
            }
        }
        .padding(.init(top: 30, leading: 25, bottom: 20, trailing: 0))
    }
    
}

