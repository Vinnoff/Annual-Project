//
//  ListTracksVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 12/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire

class ListTracksVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var idPlaylist : String?
    var tracks = [TrackMF]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.requestTracks()
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestTracks() {
        let headers: HTTPHeaders = [
            "Accept": "application/json"
        ]
        let url = "http://mocnodeserv.hopto.org:3000/playlist/allsongs/" + idPlaylist!
        Alamofire.request(url, headers: headers).responseObject { (response: DataResponse<Playlist>) in
            if let playlist = response.result.value {
                self.tracks = playlist.tracks!
                self.tableView.reloadData()
            }
        }
    }
    
    func requestRemoveTrack() {
        NSLog("REQUEST REMOVE TRACK")
    }
}

extension ListTracksVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = tracks[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Supprimer", message: "Voulez-vous supprimer cette musique de votre playlist ?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.requestRemoveTrack()
        }
        let noAction = UIAlertAction(title: "Non", style: UIAlertActionStyle.default)
        alert.addAction(okAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
}
