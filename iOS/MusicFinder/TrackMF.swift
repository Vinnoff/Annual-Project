//
//  TrackMF.swift
//  MusicFinder
//
//  Created by TRAING Serey on 12/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class TrackMF : Mappable{
    var title: String?
    var url: String?
    var uri: String?
    var id: String?
    //var artists: [Artist]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        //artists <- map["artists"]
        title <- map["title"]
        url <- map["url"]
        uri <- map["uri"]
        id <- map["_id"]
    }
}

