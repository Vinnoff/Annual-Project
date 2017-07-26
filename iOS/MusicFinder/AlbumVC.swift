//
//  AlbumVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SWRevealViewController

class AlbumVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    public var url: String?
    private var tracks = [Item]()
    private var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "cell")
        tableView.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        if UserInfoSaver().isAuth()! {
            if let session = UserInfoSaver().getSessionSpotify() {
                let token = session.accessToken
                let headers: HTTPHeaders = ["Authorization": "Bearer " + token!,
                                            "Accept": "application/json"]
                
                Alamofire.request(url!, headers: headers).responseObject(completionHandler: {
                    (response: DataResponse<Album>) in
                    if let album = response.result.value {
                        self.album = album
                        self.tracks = (album.tracks?.items!)!
                    }
                    self.tableView.reloadData()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        cell.bindData(title: self.tracks[indexPath.row].name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackVC = TrackVC(nibName: TrackVC.className(), bundle: nil)
        trackVC.item = tracks[indexPath.row]
        trackVC.album = album
        navigationController?.pushViewController(trackVC, animated: true)
    }
    
    func showAuthSpotify() {
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
        let newRootVC = UINavigationController(rootViewController: authVC)
        revealVC.pushFrontViewController(newRootVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
