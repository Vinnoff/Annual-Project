//
//  UserSpotify.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class UserSpotify : Mappable{
    
    var id : String?
    var uri: String?
    var images: ImageProfile?
    
    required init?(map: Map) {
        
    }
     
     func mapping(map: Map) {
        self.id <- map["id"]
        self.uri <- map["uri"]
        self.images <- map["images"]
     }
}

