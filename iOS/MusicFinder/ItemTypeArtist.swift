//
//  ItemTypeArtist.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class ItemTypeArtist : Mappable{
    var artists: ItemType?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        artists <- map["artists"]
    }
}
