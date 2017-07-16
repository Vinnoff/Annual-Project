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
    var tracks = [TrackMF]()
    var idPlaylistSpotify: String?
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.title = "Upload sur Spotify"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: SimpleCell.className(), bundle: nil), forCellReuseIdentifier: "cell")
        // https://api.spotify.com/v1/users/alkrox/playlists
        //Authorization: Bearer

        self.requestPlaylist()
        self.tableView.reloadData()
    }
    
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
    
    
    //1 CREER PLAYLIST
    func requestCreatePlaylist(index: Int) {
        if UserInfoSaver().isAuth()! {
            let username = UserInfoSaver().getUsername()
            if let session = UserInfoSaver().getSessionSpotify() {
                let headersSpotify: HTTPHeaders = [
                    "Authorization": "Bearer " + session.accessToken,
                    "Accept": "application/json"
                ]
                
                let parameters = [
                    "description": "",
                    "public" : "true",
                    "name" : playlists[index].title!
                    
                    ] as [String : Any]
                
                Alamofire.request("https://api.spotify.com/v1/users/" + username! + "/playlists", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headersSpotify).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        self.requestGetIdPlaylistSpotify(token: session.accessToken, index: index)
                        //self.requestTracks(index: index, token: session.accessToken)
                        
                    case .failure:
                        let alert = UIAlertController(title: "Alert", message: "Erreur création playlist", preferredStyle: UIAlertControllerStyle.alert)
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
    
    func requestTracks(index: Int) {
        let idPlaylist = playlists[index].id
        let url = "http://mocnodeserv.hopto.org:3000/playlist/allsongs/" + idPlaylist!
        Alamofire.request(url, headers: headers).responseObject { (response: DataResponse<Playlist>) in
            if let playlist = response.result.value {
                self.tracks = playlist.tracks!
                if self.tracks.count > 0 {
                    self.requestCreatePlaylist(index: index)
                } else {
                    let alert = UIAlertController(title: "Oops", message: "Il n'y a pas de musique dans cette playlist !", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    func requestGetIdPlaylistSpotify(token: String, index: Int) {
        let username = UserInfoSaver().getUsername()
        let url = "https://api.spotify.com/v1/users/" + username! + "/playlists"
        let headersSpotify: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headersSpotify).validate(statusCode: 200..<300).responseObject(completionHandler: { (response: DataResponse<PlaylistSpotify>) in
            switch response.result {
            case .success:
                if let playlistSpotify = response.result.value {
                    if let id = playlistSpotify.items?.first?.id {
                        self.requestAddSong(index: index, id: id, token: token)
                    }
                }
                
            case .failure:
                let alert = UIAlertController(title: "Alert", message: "Erreur création playlist", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
        
    }
    
    func requestAddSong(index: Int, id: String, token: String) {
        var uriUpdated = ""
        let username = UserInfoSaver().getUsername()
        let headersSpotify: HTTPHeaders = [
            "Authorization": "Bearer " + token,
            "Accept": "application/json"
        ]
        if UserInfoSaver().isAuth()! {
            for track in self.tracks {
                uriUpdated = uriUpdated + (track.uri?.replacingOccurrences(of: ":", with: "%3A", options: .literal, range: nil))! + ","
            }
            
            let url = "https://api.spotify.com/v1/users/" + username! + "/playlists/" + id + "/tracks?uris=" + uriUpdated.substring(to: uriUpdated.index(before: uriUpdated.endIndex))
            
            Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: headersSpotify).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                switch response.result {
                case .success:
                    let alert = UIAlertController(title: "Succès", message: "Votre playlist est sur Spotify !", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                case .failure:
                    let alert = UIAlertController(title: "Alert", message: "Erreur création playlist", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            })
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        cell.bindData(title: self.playlists[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.requestTracks(index: indexPath.row)
    }
}
