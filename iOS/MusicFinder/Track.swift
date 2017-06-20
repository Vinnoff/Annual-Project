//
//  Track.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class Track : Mappable{
    var album: Album?
    var artists: [Artist]?
    var duration_ms: Int?
    var href: String?
    var id: String?
    var name: String?
    var preview_url: String?
    var type: String?

    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        album <- map["album"]
        artists <- map["artists"]
        duration_ms <- map["duraton_ms"]
        href <- map["href"]
        id <- map["id"]
        name <- map["name"]
        preview_url <- map["preview_url"]
        type <- map["type"]
        
    }
}
