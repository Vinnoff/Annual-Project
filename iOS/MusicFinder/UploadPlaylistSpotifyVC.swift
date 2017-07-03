//
//  UploadPlaylistSpotifyVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 03/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire

class UploadPlaylistSpotifyVC: UIViewController {

    let url = "https://api.spotify.com/v1/users/alkrox/playlists"
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var textfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // https://api.spotify.com/v1/users/alkrox/playlists
        //Authorization: Bearer
        
        
    }

    
    @IBAction func buttonClicked(_ sender: Any) {
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            if textfield.text != nil{
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + session.accessToken,
                    "Accept": "application/json"
                ]
                let parameters = [
                    "description": "test",
                    "public" : "false",
                    "name" : textfield.text
                    
                    ] as [String : Any]
                
                Alamofire.request("https://api.spotify.com/v1/users/alkrox/playlists", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            }
        }
    }
    
    @IBAction func addClicked(_ sender: Any) {
        
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
