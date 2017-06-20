//
//  AuthOtherAccount.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Alamofire
import UIKit

class AuthOtherAccount: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    @IBOutlet weak var label: UILabel!
    var auth = SPTAuth.defaultInstance()!
    var session:SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    let userDefaults = UserDefaults()
    
    var urlInfoAccount = "https://api.spotify.com/v1/me"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(AuthOtherAccount.updateAfterFirstLogin), name: nil, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        SPTAuth.defaultInstance().clientID = "fdad9d96ab20485e954addb639fd222a"
        SPTAuth.defaultInstance().redirectURL = URL(string: "musicfinder-auth://callback")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistModifyPrivateScope]
        loginUrl = auth.spotifyWebAuthenticationURL()
    }
    
    @IBAction func loginSpotifyClicked(_ sender: Any) {
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                
            }
        }
    }
    
    @IBAction func disconnectButton(_ sender: Any) {
        userDefaults.removeObject(forKey: "SpotifySession")
    }
    
    func updateAfterFirstLogin() {
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            //print("MON ACCESS TOKEN \n n" + session.accessToken)
        }
    }

    func callAlamofire(url: String) {
        let token: String?
        
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!]
            print(headers)
            Alamofire.request(url, headers: headers).responseJSON(completionHandler: { (response) in
                if let JSON = response.result.value {
                    print(JSON)
                }
            })
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        callAlamofire(url: urlInfoAccount)
    }
}
