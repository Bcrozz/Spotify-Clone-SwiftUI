//
//  TabViewSelectedView.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 22/12/21.
//

import SwiftUI

struct TabViewSelectedView: View {
    
    @Binding var selectedView: Int
    
    var body: some View {
        GeometryReader{ geo in
            HStack(){
                if selectedView != 0 {
                    Button {
                        withAnimation {
                            selectedView = 0
                        }
                    } label: {
                        Image(systemName: "xmark.circle")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .frame(width: geo.size.width * 0.075,height: geo.size.height * 0.75)
                    }
                }
                if selectedView == 0 || selectedView == 1 {
                    Button {
                        withAnimation {
                            if selectedView == 0{
                                selectedView = 1
                            }else {
                                selectedView = 0
                            }
                        }
                    } label: {
                        Text("Playlists")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: geo.size.height * 0.75)
                            .background(
                                Capsule(style: .continuous)
                                    .stroke((selectedView == 1) ? .green : .white, lineWidth: 2)
                                    .background( (selectedView == 1) ? Capsule(style: .continuous).fill(.green.opacity(0.5)) : nil)
                            )
                    }
                }
                if selectedView == 0 || selectedView == 2 {
                    Button {
                        withAnimation {
                            if selectedView == 0{
                                selectedView = 2
                            }else {
                                selectedView = 0
                            }
                        }
                    } label: {
                        Text("Albums")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: geo.size.height * 0.75)
                            .background(
                                Capsule(style: .continuous)
                                    .stroke((selectedView == 2) ? .green : .white, lineWidth: 2)
                                    .background( (selectedView == 2) ? Capsule(style: .continuous).fill(.green.opacity(0.5)) : nil)
                            )
                    }
                }
                if selectedView == 0 || selectedView == 3 {
                    Button {
                        withAnimation {
                            if selectedView == 0{
                                selectedView = 3
                            }else {
                                selectedView = 0
                            }
                        }
                    } label: {
                        Text("Artists")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height: geo.size.height * 0.75)
                            .background(
                                Capsule(style: .continuous)
                                    .stroke((selectedView == 3) ? .green : .white, lineWidth: 2)
                                    .background( (selectedView == 3) ? Capsule(style: .continuous).fill(.green.opacity(0.5)) : nil)
                            )
                    }
                }
            }
            .padding(.init(top: geo.size.height * 0.125, leading: geo.size.width * 0.025, bottom: 0, trailing: 0))
        }
        .frame(width: UIScreen.main.bounds.width,height: UIScreen.main.bounds.height * 0.040)
        .background(Color("almostblack"))
    }
}

struct TabViewSelectedView_Previews: PreviewProvider {
    @State static var selectedIndex = 0
    static var previews: some View {
        TabViewSelectedView(selectedView: $selectedIndex)
    }
}

//VStack(alignment: .leading,spacing: 0){
//    HStack(spacing: 0){
//        Button {
//            withAnimation {
//                selectedView = 0
//            }
//        } label: {
//            Text("Playlists")
//                .font(.headline)
//                .fontWeight(.bold)
//        }
//        .frame(width: geo.size.width * 0.30,height: geo.size.height * 0.5)
//        Button {
//            withAnimation {
//                selectedView = 1
//            }
//        } label: {
//            Text("Albums")
//                .font(.headline)
//                .fontWeight(.bold)
//        }
//        .frame(width: geo.size.width * 0.30,height: geo.size.height * 0.5)
//    }
//    .padding(.top,geo.size.height * 0.25)
//    Rectangle()
//        .fill(.green)
//        .frame(width: geo.size.width * 0.30,height: geo.size.height * 0.25)
//        .offset(x: selectedView == 0 ? 0 : geo.size.width * 0.30, y: 0)
//}
