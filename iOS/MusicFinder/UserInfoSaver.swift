//
//  UserInfoSaver.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Foundation
import Alamofire

class UserInfoSaver {
    static let USER_ID_KEY = "user_id"
    
    let userDefaults: UserDefaults?
    
    init() {
        userDefaults = UserDefaults.standard
    }
    
    func getSessionSpotify() -> SPTSession? {
        if let sessionObj:AnyObject = userDefaults?.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            
            if let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as? SPTSession {
                return firstTimeSession
            }
            return nil
        }
        return nil
    }
    
    func getUserIdMusicFinder() -> String? {
        if let idUser = userDefaults?.string(forKey: "id_user") {
            return idUser
        }
        return nil
    }
    
    func getUserSpotify() -> UserSpotify? {
        let token: String?
        let urlInfoAccount = "https://api.spotify.com/v1/me"
        var user: UserSpotify?
        if let session = self.getSessionSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!,
                                        "Accept": "application/json"]
            Alamofire.request(urlInfoAccount, headers: headers).responseObject(completionHandler: {
                (response: DataResponse<UserSpotify>) in
                if let userResponse = response.result.value {
                    user = userResponse
                }
            })
        }
        return user
    }
    
    func getUserMusicFinder(username: String?) -> User? {
        var user: User?
            
        let headers: HTTPHeaders = ["Accept": "application/json"]
        let url = "http://mocnodeserv.hopto.org:3000/users/username/" + username!
        Alamofire.request(url, headers: headers).responseObject(completionHandler: {
            (response: DataResponse<User>) in
            if let userResponse = response.result.value {
                user = userResponse
            }
        })
        return user
    }
    
    func saveInfoUser() {
        let token: String?
        let urlInfoAccount = "https://api.spotify.com/v1/me"
        var userSpotify: UserSpotify?
        var userMusicFinder: User?
        
        if let session = self.getSessionSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!,
                                        "Accept": "application/json"]
            Alamofire.request(urlInfoAccount, headers: headers).responseObject(completionHandler: {
                (response: DataResponse<UserSpotify>) in
                if let userResponseSpotify = response.result.value {
                    userSpotify = userResponseSpotify
                    self.userDefaults?.set(userResponseSpotify.id, forKey: "username")
                    self.userDefaults?.synchronize()
                    
                    let headers: HTTPHeaders = ["Accept": "application/json"]
                    let url = "http://mocnodeserv.hopto.org:3000/users/username/" + (userSpotify?.id)!
                    Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                        (response: DataResponse<User>) in
                        if let userResponse = response.result.value {
                            self.userDefaults?.set(userResponse.id, forKey: "id_user")
                            self.userDefaults?.synchronize()
                        }
                    })
                }
            })
        }
    }
    
    func isAuth() -> Bool? {
        if let session = getSessionSpotify(){
             return session.isValid()
        }
        return false
    }

    func disconnectAccount() {
        userDefaults?.removeObject(forKey: "SpotifySession")
    }
}
