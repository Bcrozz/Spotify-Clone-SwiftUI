//
//  SearchView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import SwiftUI

struct SearchControlView: View {
    
    @ObservedObject var searchResultResponse = SearchResultViewModelResponse()
    
    @State var query = ""
    
    var body: some View {
        NavigationView {
            SearchView()
                .searchable(text: $query,prompt: Text("Songs, Artists, Albums, Playlists"))
                .background(Color("almostblack"))
                .navigationBarTitle("Search",displayMode: .large)
                .onSubmit(of: .search) {
                    //query api
                    searchResultResponse.fetchResultData(with: query)
                }
        }
        .environmentObject(searchResultResponse)
    }
}

struct SearchView: View {
    
    @EnvironmentObject var searchResultResponse:SearchResultViewModelResponse
    @Environment(\.isSearching) var isSearching
    
    var body: some View{
        if isSearching {
            SearchResultView()
                .environmentObject(searchResultResponse)
        }else {
            GenresSearchView()
        }
    }
    
}


struct SearchControlView_Previews: PreviewProvider {
    static var previews: some View {
        SearchControlView()
    }
}
