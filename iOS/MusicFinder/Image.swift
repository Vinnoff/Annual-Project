//
//  Image.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class Image : Mappable{
    var height: Int?
    var url: String?
    var width: Int?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        height <- map["height"]
        url <- map["url"]
        width <- map["width"]
    }
}
