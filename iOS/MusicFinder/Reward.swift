//
//  File.swift
//  MusicFinder
//
//  Created by TRAING Serey on 13/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class Reward : Mappable{
    var title: String?
    var id: String?
    var type: String?
    var goldToAccess: Int?

    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        title <- map["title"]
        id <- map["_id"]
        type <- map["type"]
        goldToAccess <- map["goldToAccess"]
    }
}
