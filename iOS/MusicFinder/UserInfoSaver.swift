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
    
    func getUsername() -> String? {
        if let username = userDefaults?.string(forKey: "username") {
            return username
        }
        return nil
    }
    
    func getTokenMF() -> String? {
        if let token = userDefaults?.string(forKey: "token_mf") {
            return token
        }
        return nil
    }
    
    func saveIdSpotify() {
        let token: String?
        let urlInfoAccount = "https://api.spotify.com/v1/me"
        if let session = self.getSessionSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!,
                                        "Accept": "application/json"]
            Alamofire.request(urlInfoAccount, headers: headers).responseObject(completionHandler: {
                (response: DataResponse<UserSpotify>) in
                if let userResponse = response.result.value {
                    self.userDefaults?.set(userResponse.id, forKey: "username")
                    self.userDefaults?.synchronize()
                }
            })
        }
    }
    
    func saveInfoUser() {
        let token: String?
        let urlInfoAccount = "https://api.spotify.com/v1/me"
        var userSpotify: UserSpotify?
        
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
                            
                            let urlAuthMF = "http://mocnodeserv.hopto.org:3000/auth/login/iOs/" + userResponse.id!
                            Alamofire.request(urlAuthMF, method: .post, headers: headers).responseString(completionHandler: {
                                (response) in
                                if let token = response.result.value {
                                    self.userDefaults?.set(token, forKey: "token_mf")
                                    self.userDefaults?.synchronize()
                                }
                            })
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
        userDefaults?.removeObject(forKey: "id_user")
        userDefaults?.removeObject(forKey: "username")
        userDefaults?.removeObject(forKey: "token_mf")
    }
}
