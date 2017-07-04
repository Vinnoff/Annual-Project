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
        self.setNavigationBarItem()
        // https://api.spotify.com/v1/users/alkrox/playlists
        //Authorization: Bearer
        
        
    }

    
    @IBAction func buttonClicked(_ sender: Any) {
        if UserInfoSaver().isAuth()! {
            if let session = UserInfoSaver().getSessionSpotify() {
                if textfield.text != nil{
                    let headers: HTTPHeaders = [
                        "Authorization": "Bearer " + session.accessToken,
                        "Accept": "application/json"
                    ]
                    let parameters = [
                        "description": "test",
                        "public" : "true",
                        "name" : textfield.text
                        
                        ] as [String : Any]
                    
                    Alamofire.request("https://api.spotify.com/v1/users/alkrox/playlists", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            print("SUCCESS")
                            let alert = UIAlertController(title: "Alert", message: "Ajouté avec succes", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        case .failure:
                            print("ERROR")
                            let alert = UIAlertController(title: "Alert", message: "ERREUR", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
    }
    
    @IBAction func addClicked(_ sender: Any) {
        //1sOYqfD1K4HYOWzi7l7iIW
        //spotify:album:6XMTRp9sURjgP9g23ppEri
        
        if UserInfoSaver().isAuth()! {
            if let session = UserInfoSaver().getSessionSpotify() {
                let uris = "spotify:track:4IIUaKqGMElZ3rGtuvYlNc"
                let playlistId = "1sOYqfD1K4HYOWzi7l7iIW"
                let urisUpdated = uris.replacingOccurrences(of: ":", with: "%3A", options: .literal, range: nil)
                let url = "https://api.spotify.com/v1/users/alkrox/playlists/" + playlistId + "/tracks?uris=" + urisUpdated
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + session.accessToken,
                    "Accept": "application/json"
                ]
                Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: headers)
            }
        }
    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
