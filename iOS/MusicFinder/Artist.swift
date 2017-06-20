//
//  Artist.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//
import Foundation
import ObjectMapper

class Artist : Mappable{
    var href: String?
    var id: String?
    var images: [Image]?
    var name: String?
    var type: String?
    var genres: [String]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        href <- map["href"]
        id <- map["id"]
        name <- map["name"]
        images <- map["images"]
        type <- map["type"]
        genres <- map["genres"]
        
    }
}
