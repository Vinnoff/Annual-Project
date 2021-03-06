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
        self.title = "Quizz"
        self.tableView.register(UINib(nibName: SimpleCell.className(), bundle: nil), forCellReuseIdentifier: "cell")
        self.requestPlaylist()
    }

    func requestPlaylist() {
        let url = "http://mocnodeserv.hopto.org:80/playlist/"
        Alamofire.request(url, headers: headers).responseArray { (response: DataResponse<[Playlist]>) in
            if let playlists = response.result.value {
                self.playlists = playlists
                self.tableView.reloadData()
            }
        }
    }

    func requestCreationGame(playlist: Playlist) {
        let url = "http://mocnodeserv.hopto.org:80/game/"
        var tabIdSong = [String]()
        
        
        let urlGetSongs = "http://mocnodeserv.hopto.org:80/playlist/allsongs/" + playlist.id!
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
                
                let headersMF: HTTPHeaders = ["Authorization": UserInfoSaver().getTokenMF()!,
                                            "Accept": "application/json"]
                
                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headersMF).responseObject(completionHandler: { (response: DataResponse<Quizz>) in
                    switch response.result {
                    case .success:
                        if let quizz = response.result.value {
                            let detailMusicVC = DetailMusicVC(nibName: DetailMusicVC.className(), bundle: nil)
                            detailMusicVC.quizz = quizz
                            self.navigationController?.pushViewController(detailMusicVC, animated: true)
                        }
                        
                    case .failure:
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        cell.bindData(title: self.playlists[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.playlists[indexPath.row].tracks?.count == 0 {
            let alert = UIAlertController(title: "Oops !", message: "Il n'y aucune musique dans cette playlist", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            requestCreationGame(playlist: playlists[indexPath.row])
        }
        
    }
}
