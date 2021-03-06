//
//  ArtistVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 16/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SWRevealViewController

class ArtistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var artist: Item?
    var tracks = [Track]()
    var albums = [Item]()
    var itemTypeAlbum: ItemType?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ResultSearchCell", bundle: nil), forCellReuseIdentifier: "resultcell")
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.containerView.layer.cornerRadius = 10.0
        if artist != nil {
            let urlTopTrack = "https://api.spotify.com/v1/artists/" + (artist?.id)! + "/top-tracks?country=Fr"
            let urlAlbum = "https://api.spotify.com/v1/artists/" + (artist?.id)! + "/albums?album_type=album"
            requestTrackArtist(url: urlTopTrack)
            requestAlbumArtist(url: urlAlbum)
            
            if let imageURL = artist?.images?.first?.url {
                let url = URL(string: imageURL)
                let data = try? Data(contentsOf: url!)
                imageView.image = UIImage(data: data!)
            }
            self.nameLabel.text = artist?.name
            var allGenres = ""
            for genre in (artist?.genres)! {
                allGenres = allGenres + genre + " "
            }
            self.genreLabel.text = allGenres
        }
    }

    func requestTrackArtist(url: String) {
        let token: String?
        if UserInfoSaver().isAuth()! {
            if let session = UserInfoSaver().getSessionSpotify() {
                token = session.accessToken
                let headers: HTTPHeaders = ["Authorization": "Bearer " + token!,
                                            "Accept": "application/json"]
                Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                    (response: DataResponse<TopTrack>) in
                    if let topTracks = response.result.value {
                        for track in topTracks.tracks! {
                            self.tracks.append(track)
                        }
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
    
    func requestAlbumArtist(url: String) {
        let token: String?
        if UserInfoSaver().isAuth()! {
            if let session = UserInfoSaver().getSessionSpotify() {
                token = session.accessToken
                let headers: HTTPHeaders = ["Authorization": "Bearer " + token!,
                                            "Accept": "application/json"]
                Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                    (response: DataResponse<ItemType>) in
                    if let itemType = response.result.value {
                        self.itemTypeAlbum = itemType
                        for album in itemType.items! {
                            self.albums.append(album)
                        }
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
            if indexPath.row % 2 == 0 {
                cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
            } else {
                cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
            }
            cell.bindData(title: self.tracks[indexPath.row].name)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultcell", for: indexPath) as! ResultSearchCell
            if indexPath.row % 2 == 0 {
                cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
            } else {
                cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
            }
            if  (albums[indexPath.row].images?.isEmpty)! {
                cell.bindData(title: albums[indexPath.row].name)
            } else {
                cell.bindData(title: albums[indexPath.row].name, imageURL:  albums[indexPath.row].images?[1].url)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 80.0
        }
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tracks.count
        }
        
        else if section == 1 {
            return albums.count
        }
        
        else {
            return 0
        }

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Les plus populaires"
        } else {
            return "Albums"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let trackVC = TrackVC(nibName: TrackVC.className(), bundle: nil)
            trackVC.track = tracks[indexPath.row]
            navigationController?.pushViewController(trackVC, animated: true)
        } else {
            let albumVC = AlbumVC(nibName: AlbumVC.className(), bundle: nil)
            albumVC.url = albums[indexPath.row].href
            navigationController?.pushViewController(albumVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = albums.count - 1
        if indexPath.row == lastElement {
            if itemTypeAlbum?.next != nil {
                let searchUrlNext = itemTypeAlbum?.next
                requestAlbumArtist(url: searchUrlNext!)
            }
        }
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
