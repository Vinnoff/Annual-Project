//
//  User.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class User : Mappable{
    var username: String?
    var id: String?
    var playlist: [Playlist]?
    var rank: Rank?
    var friends: [User]?
    var gold: Int?
    var games: [Quizz]?
    var globalScore: Int?
    var rewards: [Reward]?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        username <- map["userName"]
        id <- map["_id"]
        playlist <- map["Playlists"]
        rank <- map["Rank"]
        friends <- map["Friends"]
        gold <- map["gold"]
        games <- map["Games"]
        globalScore <- map["globalScore"]
        rewards <- map["Rewards"]
    }
}
