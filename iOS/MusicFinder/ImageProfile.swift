//
//  ImageProfile.swift
//  MusicFinder
//
//  Created by TRAING Serey on 08/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import Foundation
import ObjectMapper

class ImageProfile : Mappable{
    
    var url: String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        self.url <- map["url"]
    }
}

