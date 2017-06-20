//
//  ItemType.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class ItemType : Mappable{
    var href: String?
    var items: [Item]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        href <- map["href"]
        items <- map["items"]
        limit <- map["limit"]
        next <- map["next"]
        offset <- map["offset"]
        previous <- map["previous"]
        total <- map["total"]
    }
}
