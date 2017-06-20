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

class ArtistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var artist: Item?
    var tracks = [Track]()
    var albums = [Item]()
    var itemTypeAlbum: ItemType?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ResultSearchCell", bundle: nil), forCellReuseIdentifier: "resultcell")
        
        if artist != nil {
            let urlTopTrack = "https://api.spotify.com/v1/artists/" + (artist?.id)! + "/top-tracks?country=Fr"
            let urlAlbum = "https://api.spotify.com/v1/artists/" + (artist?.id)! + "/albums?album_type=album"
            requestTrackArtist(url: urlTopTrack)
            requestAlbumArtist(url: urlAlbum)
        }
    }

    func requestTrackArtist(url: String) {
        let token: String?
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!]
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
    }
    
    func requestAlbumArtist(url: String) {
        let token: String?
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!]
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
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.textLabel?.text = tracks[indexPath.row].name
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultcell", for: indexPath) as! ResultSearchCell
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
