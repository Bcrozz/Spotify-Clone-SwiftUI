//
//  RecommendationTracksViewCell.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 18/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct RecommendationTracksViewCell: View {
    let isTopTracks: Bool
    let recommenTrackViewModel: RecommendedTrackCellViewModel?
    let userTopTrackViewModel: UserTopTracksCellViewModel?
    
    init(_ isTopTracks: Bool,_ recommenTrackViewModel: RecommendedTrackCellViewModel?,_ userTopTrackViewModel: UserTopTracksCellViewModel?){
        self.isTopTracks = isTopTracks
        self.recommenTrackViewModel = recommenTrackViewModel
        self.userTopTrackViewModel = userTopTrackViewModel
    }
    
    var body: some View {
        HStack{
            if isTopTracks {
                WebImage(url: userTopTrackViewModel?.artworkURL)
                    .resizable()
                    .aspectRatio(1,contentMode: .fit)
            }else {
                WebImage(url: recommenTrackViewModel?.artworkURL)
                    .resizable()
                    .aspectRatio(1,contentMode: .fit)
            }
            VStack(alignment: .leading){
                if isTopTracks {
                    Text(userTopTrackViewModel?.name ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(userTopTrackViewModel?.artistName ?? "")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                    Spacer()
                    Text(userTopTrackViewModel?.albumName ?? "")
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                }else {
                    Text(recommenTrackViewModel?.name ?? "")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text(recommenTrackViewModel?.artistName ?? "")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.bottom,10)
                }
            }
            .frame(width: 200,alignment: .leading)
            .padding(.init(top: 3, leading: 0, bottom: 3, trailing: 0))
        }
        .frame(minWidth: UIScreen.main.bounds.width * 0.8,minHeight: 100,maxHeight: 120,alignment: .leading)
        .background(.gray.opacity(0.15))
    }
}

