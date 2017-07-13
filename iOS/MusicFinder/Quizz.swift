//
//  Quizz.swift
//  MusicFinder
//
//  Created by TRAING Serey on 13/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class Quizz : Mappable{
    var id: String?
    var difficulty: Int?
    var isPublic: Bool?
    var isMultiplayer: Bool?
    var scores: [Score]?
    var tracks: [TrackMF]?
    
    required init?(map: Map){
    }
    
    func mapping(map: Map) {
        id <- map["_id"]
        difficulty <- map["difficulty"]
        isPublic <- map["isPublic"]
        isMultiplayer <- map["isMultiplayer"]
        scores <- map["Scores"]
        tracks <- map["Songs"]
    }
}
