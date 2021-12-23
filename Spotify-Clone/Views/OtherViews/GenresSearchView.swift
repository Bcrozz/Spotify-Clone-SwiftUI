//
//  GenresSearchView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 21/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct GenresSearchView: View {
    
    @ObservedObject var genresearchResponse = GenreSearchViewModelResponse()
    
    let columes = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible())
    ]
    
    init(){
        genresearchResponse.fetchData()
    }
    
    var body: some View{
        ScrollView(showsIndicators: false) {
            if genresearchResponse.categoriesViewModel.count > 0 {
                LazyVGrid(columns: columes,spacing: 15) {
                    ForEach(0..<genresearchResponse.categoriesViewModel.count) { index in
                        NavigationLink(destination: GenreView(with: genresearchResponse.categories[index])) {
                            GenresSearchViewCell(with: genresearchResponse.categoriesViewModel[index])
                        }
                    }
                }
                .padding()
            }
        }
    }
}

struct GenresSearchView_Previews: PreviewProvider {
    static var previews: some View {
        GenresSearchView()
    }
}

struct GenresSearchViewCell: View {
    
    private let colors: [Color] = [
        .yellow,
        .red,
        .blue,
        .brown,
        .green,
        .orange,
        .pink,
        .purple,
        .gray
    ]
    
    let viewModel: CategoryCollectionViewCellViewModel
    
    init(with viewModel: CategoryCollectionViewCellViewModel){
        self.viewModel = viewModel
    }
    
    var body: some View{
        GeometryReader { geo in
            VStack{
                HStack{
                    Spacer()
                    WebImage(url: viewModel.artworkURL)
                        .resizable()
                        .frame(width: geo.size.width * 0.6,height: geo.size.height * 0.5)
                        .cornerRadius(10)
                }
                HStack{
                    Text(viewModel.title ?? "")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: geo.size.width * 0.9,alignment: .leading)
                    Spacer()
                }
            }
        }
        .frame(height: UIScreen.main.bounds.height * 0.2)
        .background(colors.randomElement())
        .cornerRadius(20)
    }
    
}
