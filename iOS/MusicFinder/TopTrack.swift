//
//  TopTrack.swift
//  MusicFinder
//
//  Created by TRAING Serey on 18/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class TopTrack : Mappable{
    var tracks: [Track]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        tracks <- map["tracks"]
    }
}
