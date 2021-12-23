//
//  SettingView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 23/12/21.
//

import SwiftUI

struct SettingView: View {
    
    @State var isPresentAlert = false
    @State var isPresentWelcome = false
    
    var body: some View {
        List {
            NavigationLink(destination: ProfileView()) {
                Text("Profile")
            }
            Button {
                isPresentAlert.toggle()
            } label: {
                Text("Sign Out")
            }
            .alert(Text("Sign Out"), isPresented: $isPresentAlert) {
                Button(role: .cancel, action: {}, label: { Text("Cancel") })
                Button(role: .destructive) {
                    AuthManager.shared.signOut { signedOut in
                        if signedOut {
                            isPresentWelcome.toggle()
                        }
                    }
                } label: {
                    Text("Sign Out")
                }
            } message: {
                Text("Are you sure?")
            }
        }
        .background(Color("almostblack"))
        .navigationBarTitle("Setting",displayMode: .inline)
        .fullScreenCover(isPresented: $isPresentWelcome, onDismiss: nil) {
            WelcomeView()
                .edgesIgnoringSafeArea(.all)
                .preferredColorScheme(.dark)
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
