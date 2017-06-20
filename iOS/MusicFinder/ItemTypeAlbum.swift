//
//  ItemTypeAlbum.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class ItemTypeAlbum : Mappable{
    var albums: ItemType?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        albums <- map["albums"]
    }
}
