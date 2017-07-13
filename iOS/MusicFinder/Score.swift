//
//  Score.swift
//  MusicFinder
//
//  Created by TRAING Serey on 13/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class Score : Mappable{
    var id: String?
    var score: String?
    var playerId: String?

    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        score <- map["Score"]
        playerId <- map["Player"]
    }
}
