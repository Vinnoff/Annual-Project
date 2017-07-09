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
    //private var imageUrlToSend: String?
    private var album: Album?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.darkGray
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
                        /*if !(album.images?.isEmpty)! {
                         self.imageUrlToSend = album.images?[0].url
                         }*/
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
        let cell = UITableViewCell()
        if let name = tracks[indexPath.row].name {
            cell.textLabel?.text = name
            cell.backgroundColor = UIColor.darkGray
            cell.textLabel?.textColor = UIColor(red: 255, green: 229, blue: 53)
        }
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
