//
//  UploadPlaylistSpotifyVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 03/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire
import SWRevealViewController

class UploadPlaylistSpotifyVC: UIViewController {

    let url = "https://api.spotify.com/v1/users/alkrox/playlists"
    var playlists = [Playlist]()
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // https://api.spotify.com/v1/users/alkrox/playlists
        //Authorization: Bearer

        self.requestPlaylist()
        self.tableView.reloadData()
    }
    
    
    
    /*@IBAction func addClicked(_ sender: Any) {
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
    }*/
    
    
    func showAuthSpotify() {
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
        let newRootVC = UINavigationController(rootViewController: authVC)
        revealVC.pushFrontViewController(newRootVC, animated: true)
    }
    
    func requestPlaylist() {
        let id = UserInfoSaver().getUserIdMusicFinder()
        let url = "http://mocnodeserv.hopto.org:3000/playlist/user/" + id!
        Alamofire.request(url, headers: headers).responseArray { (response: DataResponse<[Playlist]>) in
            if let playlists = response.result.value {
                self.playlists = playlists
                self.tableView.reloadData()
            }
        }
    }
    
    func requestCreatePlaylist(index: Int) {
        if UserInfoSaver().isAuth()! {
            let username = UserInfoSaver().getUsername()
            if let session = UserInfoSaver().getSessionSpotify() {
                
                let headers: HTTPHeaders = [
                    "Authorization": "Bearer " + session.accessToken,
                    "Accept": "application/json"
                ]
                let parameters = [
                    "description": "",
                    "public" : "true",
                    "name" : playlists[index].title!
                    
                    ] as [String : Any]
                
                Alamofire.request("https://api.spotify.com/v1/users/" + username! + "/playlists", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        /*print("SUCCESS")
                        let alert = UIAlertController(title: "Alert", message: "Ajouté avec succes", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)*/
                        
                        self.requestAddSong(index: index)
                        
                    case .failure:
                        print("ERROR")
                        let alert = UIAlertController(title: "Alert", message: "ERREUR", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
                
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Pas connecté à Spotify", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Se connecter", style: UIAlertActionStyle.default, handler: { action in
                self.showAuthSpotify()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func requestAddSong(index: Int) {
        if UserInfoSaver().isAuth()! {
            if let session = UserInfoSaver().getSessionSpotify() {
                //PICH TODO
                /*for track in playlists[index].tracks {
                    
                }*/
                
                
                
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

extension UploadPlaylistSpotifyVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = playlists[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        requestCreatePlaylist(index: indexPath.row)
    }
}
