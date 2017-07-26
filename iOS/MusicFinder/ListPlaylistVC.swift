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
import SWRevealViewController

class ListPlaylistVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
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
        self.title = "Playlists"
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "cell")
        if fromUser {
            self.requestPlaylists()
        } else {
            self.setNavigationBarItem()
            self.addGestureMenu()
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ListPlaylistVC.longPress(longPressGestureRecognizer:)))
            longPress.minimumPressDuration = 1.0
            longPress.delegate = self
            tableView.addGestureRecognizer(longPress)
            self.requestPlaylists()
        }
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestPlaylists() {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let id = UserInfoSaver().getUserIdMusicFinder()
        let url = "http://mocnodeserv.hopto.org:80/playlist/user/" + id!
        Alamofire.request(url, headers: headers).responseArray { (response: DataResponse<[Playlist]>) in
            if let playlists = response.result.value {
                self.playlists = playlists
                self.tableView.reloadData()
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
        if fromUser {
            if let idplaylist = playlists[indexPath.row]?.id {
                let url = "http://mocnodeserv.hopto.org:80/playlist/addsong/" + idplaylist
                var parameters = [:] as [String : Any]

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
                
                let headersMF: HTTPHeaders = ["Authorization": UserInfoSaver().getTokenMF()!,
                                              "Accept": "application/json"]
                
                Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headersMF).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        let alert = UIAlertController(title: "Succès", message: "Ajoutée avec succès", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                        
                    case .failure:
                        let alert = UIAlertController(title: "Alert", message: "ERREUR ajout musique dans playlist \(response.response?.statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }
        }
        else {
            if self.playlists[indexPath.row]?.tracks?.count == 0 {
                let alert = UIAlertController(title: "Oops !", message: "Il n'y a aucune musique", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let listTracksVC = ListTracksVC(nibName: ListTracksVC.className(), bundle: nil)
                listTracksVC.idPlaylist = self.playlists[indexPath.row]?.id
                navigationController?.pushViewController(listTracksVC, animated: true)
            }
            
        }
    }
    
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
                self.askDeletePlaylist(index: indexPath.row)
            }
        }
    }
    
    func askDeletePlaylist(index: Int?) {
        if let id = self.playlists[index!]?.id {
            let url = "http://mocnodeserv.hopto.org:80/playlist/" + id
            let alert = UIAlertController(title: "Attention", message: "Voulez-vous supprimer la playlist ?", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.requestDeletePlaylist(url: url, index: index!)
            }
            alert.addAction(yesAction)
            alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func requestDeletePlaylist(url: String, index: Int) {
        let headersMF: HTTPHeaders = ["Authorization": UserInfoSaver().getTokenMF()!,
                                      "Accept": "application/json"]
        
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headersMF).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Succès", message: "La playlist est supprimée", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.playlists.remove(at: index)
                    self.tableView.reloadData()
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
            case .failure:
                let alert = UIAlertController(title: "Alert", message: "ERREUR suppression playlist", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    
    @IBAction func addPlaylistClicked(_ sender: Any) {
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        if UserInfoSaver().isAuth()! {
            let createPlaylistVC = CreatePlaylistVC(nibName: CreatePlaylistVC.className(), bundle: nil)
            let newRootVC = UINavigationController(rootViewController: createPlaylistVC)
            revealVC.pushFrontViewController(newRootVC, animated: true)
        } else {
            let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
            let newRootVC = UINavigationController(rootViewController: authVC)
            revealVC.pushFrontViewController(newRootVC, animated: true)
        }

    }
}
