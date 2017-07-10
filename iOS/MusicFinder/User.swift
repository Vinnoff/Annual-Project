//
//  User.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable{
    var username: String?
    var id: String?
 
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        username <- map["userName"]
        id <- map["_id"]
    }
}
