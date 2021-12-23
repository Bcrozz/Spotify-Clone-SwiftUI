//
//  LibraryView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import SwiftUI

struct LibraryView: View {
    
    @ObservedObject var libraryResponse = LibraryViewModelResponse()
    
    @State var selectionIndex = 0
    
    init(){
        libraryResponse.fetchData()
    }
    
    var body: some View {
        NavigationView{
            ScrollView(.init()){
                TabView(selection: $selectionIndex){
                    if libraryResponse.sections.count > 0{
                        UserAllLibraryView()
                            .tag(0)
                            .environmentObject(libraryResponse)
                        ForEach(0..<3) { index in
                            switch libraryResponse.sections[index]{
                            case .UserPlaylist(let playlists,let viewModels):
                                UserPlaylistView(playlists,nil,nil,viewModels)
                                    .tag(1)
                                    .padding(.top,UIScreen.main.bounds.height * 0.040)
                            case .UserAlbum(let albums,let viewModels):
                                UserPlaylistView(nil,albums,nil,viewModels)
                                    .tag(2)
                                    .padding(.top,UIScreen.main.bounds.height * 0.040)
                            case .UserSavedArtist(let artists,let viewModels):
                                UserPlaylistView(nil,nil,artists,viewModels)
                                    .tag(3)
                                    .padding(.top,UIScreen.main.bounds.height * 0.040)
                            }
                        }
                    }
                }
                .overlay(
                    TabViewSelectedView(selectedView: $selectionIndex)
                        .onTapGesture {
                            withAnimation {
                                if selectionIndex == 0{
                                    selectionIndex = 1
                                }else {
                                    selectionIndex = 0
                                }
                            }
                        }
                    ,alignment: .top
                )
            }
            .background(Color("almostblack"))
            .navigationBarTitle("Your Library",displayMode: .inline)
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

struct UserAllLibraryView: View {
    
    @EnvironmentObject var libraryResponse: LibraryViewModelResponse
    
    var body: some View{
        ScrollView(showsIndicators: false){
            VStack(spacing: 15){
                ForEach(0..<3) { index in
                    switch libraryResponse.sections[index]{
                    case .UserPlaylist(let playlists,let viewModels):
                        UserAlbumView(playlists,nil,nil,viewModels)
                    case .UserAlbum(let albums,let viewModels):
                        UserAlbumView(nil,albums,nil,viewModels)
                    case .UserSavedArtist(let artists,let viewModels):
                        UserAlbumView(nil,nil,artists,viewModels)
                    }
                }
            }
        }
        .padding(.init(top: UIScreen.main.bounds.height * 0.040 + 20, leading: 10, bottom: 0, trailing: 10))
        .background(Color("almostblack"))
    }
}
