//
//  UserSavedArtist.swift
//  Spotify-Clone
//
//  Created by Kittisak Boonchalee on 22/12/21.
//

import Foundation
import ObjectMapper

struct UserSavedArtistResponse: Mappable {
    let items: [Artist]?
    
    init?(map: Map) {
        items = try? map.value("artists.items")
    }
    
    mutating func mapping(map: Map) {
        
    }
    
    
}
