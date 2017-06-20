//
//  UserInfoSaver.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation

class UserInfoSaver {
    static let USER_ID_KEY = "user_id"
    
    let userDefaults: UserDefaults?
    
    init() {
        userDefaults = UserDefaults.standard
    }
    
    func isAuthenticatedSpotify() -> SPTSession? {
        if let sessionObj:AnyObject = userDefaults?.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            return firstTimeSession
        }
        return nil
    }

}
