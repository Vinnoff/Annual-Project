//
//  Playlist.swift
//  MusicFinder
//
//  Created by TRAING Serey on 08/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class Playlist : Mappable{
    var id: String?
    var title: String?
    var creator: String?
    var image: String?
    var tracks: [TrackMF]?

    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        title <- map["title"]
        creator <- map["Creator"]
        image <- map["image"]
        tracks <- map["Songs"]
    }
}
