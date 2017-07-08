//
//  AuthOtherAccount.swift
//  MusicFinder
//
//  Created by TRAING Serey on 20/05/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import Alamofire
import UIKit
import SWRevealViewController

class AuthOtherAccount: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {

    @IBOutlet weak var loginButton: UIButton!
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
        self.addGestureMenu()
        loginButton.layer.cornerRadius = 5.0
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(AuthOtherAccount.updateAfterFirstLogin), name: nil, object: nil)
        callAlamofire(url: urlInfoAccount)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
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
                /*var revealVC: SWRevealViewController
                revealVC = self.revealViewController()
                let homeVC = Home2VC(nibName: Home2VC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: homeVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)*/
            }
        }
    }
    
    @IBAction func disconnectButton(_ sender: Any) {
        userDefaults.removeObject(forKey: "SpotifySession")
    }
    
    func updateAfterFirstLogin() {
        if UserInfoSaver().isAuth()! {
            
        }
    }

    func callAlamofire(url: String) {
        let token: String?
        
        if let session = UserInfoSaver().getSessionSpotify() {
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
}
