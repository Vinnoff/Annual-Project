//
//  PlaylistSpotify.swift
//  MusicFinder
//
//  Created by TRAING Serey on 14/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class PlaylistSpotify : Mappable{
    var items: [PlaylistSpotify]?
    var id: String?
    var name: String?
    var images: [Image]?

    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        items <- map["items"]
        id <- map["id"]
        name <- map["name"]
        images <- map["images"]
    }
}
