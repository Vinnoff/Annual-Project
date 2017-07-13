//
//  ListQuizzVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 13/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire

class ListQuizzVC: UIViewController {
    
    var playlists = [Playlist]()
    var tracks = [TrackMF]()
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.requestPlaylist()
        
    }
    
    
    func requestPlaylist() {
        let url = "http://mocnodeserv.hopto.org:3000/playlist/"
        Alamofire.request(url, headers: headers).responseArray { (response: DataResponse<[Playlist]>) in
            if let playlists = response.result.value {
                self.playlists = playlists
                self.tableView.reloadData()
            }
        }
    }
    
    func requestTracks(idPlaylist: String) {
        
        
    }

    func requestCreationGame(playlist: Playlist) {
        let url = "http://mocnodeserv.hopto.org:3000/game/"
        var tabIdSong = [String]()
        
        
        let urlGetSongs = "http://mocnodeserv.hopto.org:3000/playlist/allsongs/" + playlist.id!
        Alamofire.request(urlGetSongs, headers: headers).responseObject { (response: DataResponse<Playlist>) in
            if let playlist = response.result.value {
                self.tracks = playlist.tracks!
                
                for track in self.tracks {
                    tabIdSong.append(track.id!)
                }
                
                let parameters = [
                    "Players": [UserInfoSaver().getUserIdMusicFinder()],
                    "Songs": tabIdSong
                ] as [String : Any]
                
                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers).responseObject(completionHandler: { (response: DataResponse<Quizz>) in
                    switch response.result {
                    case .success:
                        if let quizz = response.result.value {
                            let listQuizzSongs = ListQuizzSongsVC(nibName: ListQuizzSongsVC.className(), bundle: nil)
                            listQuizzSongs.quizz = quizz
                            self.navigationController?.pushViewController(listQuizzSongs, animated: true)
                        }
                        
                        
                        
                    case .failure:
                        print("ERROR")
                        let alert = UIAlertController(title: "Alert", message: "ERREUR création musique \(response.response?.statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ListQuizzVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.playlists[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        requestCreationGame(playlist: playlists[indexPath.row])
    }
}


//LIste playlist > liste amis > creer requete post > attendre reponse > 


//Id score dans la requete poste
//Envoie score: http://mocnodeserv.hopto.org:3000/game/score/:id  id score
//Creation game post : http://mocnodeserv.hopto.org:3000/game/
//
