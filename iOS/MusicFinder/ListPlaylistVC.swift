//
//  ListPlaylistVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 08/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import AlamofireObjectMapper
import Alamofire

class ListPlaylistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!

    var playlists = [Playlist?]()
    
    //Add
    var fromUser = false
    var trackItem: Item?
    var track: Track?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "cell")
        if fromUser {
            requestPlaylists(fromUser: true)
        } else {
            self.setNavigationBarItem()
            self.addGestureMenu()
            requestPlaylists()
        }
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestPlaylists(fromUser: Bool = false) {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        if fromUser {
            let id = UserInfoSaver().getUserIdMusicFinder()
            let url = "http://mocnodeserv.hopto.org:3000/playlist/user/" + id!
            Alamofire.request(url, headers: headers).responseArray { (response: DataResponse<[Playlist]>) in
                if let playlists = response.result.value {
                    self.playlists = playlists
                    self.tableView.reloadData()
                }
            }
        } else {
            let url = "http://mocnodeserv.hopto.org:3000/playlist/"
            Alamofire.request(url, headers: headers).responseArray { (response: DataResponse<[Playlist]>) in
                if let playlists = response.result.value {
                    self.playlists = playlists
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        cell.bindData(title: self.playlists[indexPath.row]?.title)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Add song
        if fromUser {
            if let idplaylist = playlists[indexPath.row]?.id {
                let url = "http://mocnodeserv.hopto.org:3000/playlist/addsong/" + idplaylist
                var parameters = [:] as [String : Any]
                /*if trackItem != nil {
                    parameters = [
                        "title": trackItem?.name,
                        "url" : trackItem?.preview_url,
                        "uri" : trackItem?.uri
                    ]
                } else if track != nil {
                    parameters = [
                        "title": track?.name,
                        "url" : track?.preview_url,
                        "uri" : track?.uri
                    ]
                }*/
                
                if trackItem != nil {
                    parameters = [
                        "Song": [
                                    "title" : trackItem?.name,
                                    "url" : trackItem?.preview_url,
                                    "uri" : trackItem?.uri
                                ],
                        "Artist": [
                                    "title": trackItem?.artists?[0].name
                                  ]
                    ]
                } else if track != nil {
                    parameters = [
                        "Song": [
                            "title" : track?.name,
                            "url" : track?.preview_url,
                            "uri" : track?.uri
                        ],
                        "Artist": [
                            "title": track?.artists?[0].name
                        ]
                    ]
                }
                
                let headers: HTTPHeaders = [
                    "Accept": "application/json"
                ]
                
                Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        print("SUCCESS")
                        let alert = UIAlertController(title: "Succès", message: "Ajoutée avec succès", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    case .failure:
                        print("ERROR")
                        let alert = UIAlertController(title: "Alert", message: "ERREUR ajout musique dans playlist", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
        else {
            let listTracksVC = ListTracksVC(nibName: ListTracksVC.className(), bundle: nil)
            listTracksVC.idPlaylist = self.playlists[indexPath.row]?.id
            navigationController?.pushViewController(listTracksVC, animated: true)
        }
    }
}
