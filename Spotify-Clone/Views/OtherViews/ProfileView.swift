//
//  ProfileView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 23/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileView: View {
    
    @ObservedObject var profileResponse = ProfileViewModelResponse()
    
    init(){
        profileResponse.getCurrentUserProfile()
    }
    
    var body: some View {
        VStack {
            if profileResponse.userProfile.count > 0 {
                WebImage(url: URL(string: profileResponse.userProfile.first?.images?.first?.url ?? ""))
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: UIScreen.main.bounds.width * 0.50)
                Text(profileResponse.userProfile.first?.displayName ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
                    .frame(height: 50)
                VStack(alignment: .leading,spacing: 5) {
                    HStack(alignment: .firstTextBaseline){
                        Text("ID :")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(profileResponse.userProfile.first?.id ?? "")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    HStack(alignment: .firstTextBaseline){
                        Text("Subscription :")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(profileResponse.userProfile.first?.productType ?? "")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    HStack(alignment: .firstTextBaseline){
                        Text("Spotify Link : ")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text(profileResponse.userProfile.first?.externalURL ?? "")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("almostblack"))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
