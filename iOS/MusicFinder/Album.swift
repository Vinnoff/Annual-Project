//
//  Album.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class Album: Mappable {
    var album_type: String?
    var artists: [Artist]?
    var href: String?
    var id: String?
    var images: [Image]?
    var name: String?
    var type: String?
    var label: String?
    var release_date: String?
    var tracks: ItemType?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        album_type <- map["album_type"]
        artists <- map["artists"]
        href <- map["href"]
        id <- map["id"]
        name <- map["name"]
        images <- map["images"]
        type <- map["type"]
        label <- map["label"]
        release_date <- map["release_date"]
        tracks <- map["tracks"]
    }
}
