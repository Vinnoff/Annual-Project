//
//  User.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import ObjectMapper

class User : NSObject, NSCoding, Mappable{
    var username: String?
    var id: String?
 
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        username <- map["userName"]
        id <- map["_id"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObject(forKey: "username") as? String
        self.id = aDecoder.decodeObject(forKey: "id") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.username, forKey: "username");
        aCoder.encode(self.id, forKey: "id");
    }
}
