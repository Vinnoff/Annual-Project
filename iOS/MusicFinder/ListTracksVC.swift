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
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.requestTracks()
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestTracks() {
        
        let url = "http://mocnodeserv.hopto.org:3000/playlist/allsongs/" + idPlaylist!
        Alamofire.request(url, headers: headers).responseObject { (response: DataResponse<Playlist>) in
            if let playlist = response.result.value {
                self.tracks = playlist.tracks!
                self.tableView.reloadData()
            }
        }
    }
    
    func requestRemoveTrack(idTrack: String?) {
        let url = "http://mocnodeserv.hopto.org:3000/playlist/delsong/" + idPlaylist! + "/" + idTrack!
        
        Alamofire.request(url, method: .put, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                print("SUCCESS")
                let alert = UIAlertController(title: "Succès", message: "Supprimée avec succès", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
                
            case .failure:
                print("ERROR")
                let alert = UIAlertController(title: "Alert", message: "ERREUR suppression musique dans playlist", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}

extension ListTracksVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        cell.bindData(title: self.tracks[indexPath.row].title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Supprimer", message: "Voulez-vous supprimer cette musique de votre playlist ?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.requestRemoveTrack(idTrack: self.tracks[indexPath.row].id)
        }
        let noAction = UIAlertAction(title: "Non", style: UIAlertActionStyle.default)
        alert.addAction(okAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)
    }
}
