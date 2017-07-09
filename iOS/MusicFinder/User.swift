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
 
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        username <- map["userName"]
        id <- map["_id"]
    }
    
    /*required convenience init(coder aDecoder: NSCoder) {
        /*let id = aDecoder.decodeObject(forKey: "id") as! String
        let username = aDecoder.decodeObject(forKey: "username") as! String
        self.id = id
        self.username = username
    }*/
    
    func encode(with aCoder: NSCoder) {
        /*aCoder.encode(id, forKey: "id")
        aCoder.encode(username, forKey: "username")*/
    }*/
}
