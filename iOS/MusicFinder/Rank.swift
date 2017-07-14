//
//  Rank.swift
//  MusicFinder
//
//  Created by TRAING Serey on 13/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class Rank : Mappable{
    var id: String?
    var nb: Int?
    var title: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        nb <- map["nb"]
        id <- map["_id"]
        title <- map["title"]
    }
}

