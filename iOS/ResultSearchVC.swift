//
//  ResultSearchVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SWRevealViewController

class ResultSearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var searchWord = ""
    var searchType = "track"
    var searchWordUpdated = ""
    var searchUrl: String?
    var names = [String]()
    var imagesTest = [String]()
    var allItems = [Item]()
    var albums: ItemType?
    var artists: ItemType?
    var tracks: ItemType?
    
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var segmentedBar: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.edgesForExtendedLayout = []
        noResultView.isHidden = true
        
        self.tableView.register(UINib(nibName: "ResultSearchCell", bundle: nil), forCellReuseIdentifier: "resultcell")
        searchWordUpdated = searchWord.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
        requestResult(url: searchUrl!, type: searchType)
    }

    func requestResult(url: String, type: String?) {
        let token: String?
        if UserInfoSaver().isAuth()! {
            if let session = UserInfoSaver().getSessionSpotify() {
                token = session.accessToken
                let headers: HTTPHeaders = ["Authorization": "Bearer " + token!,
                                            "Accept": "application/json"]
                
                if type == "track" {
                    //Track
                    Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                        (response: DataResponse<ItemTypeTrack>) in
                        if let itemType = response.result.value {
                            self.tracks = itemType.tracks
                            
                            if let items = self.tracks?.items {
                                for item in items {
                                    self.allItems.append(item)
                                    self.names.append(item.name!)
                                    if let images = item.album?.images {
                                        if images.indices.contains(2) {
                                            self.imagesTest.append(images[2].url!)
                                        }
                                    }
                                    
                                }
                            }

                        }
                        if self.names.count == 0 {
                            self.noResultView.isHidden = false
                        }else {
                            self.noResultView.isHidden = true
                        }
                        self.tableView.reloadData()
                    })
                }
                else if type == "album" {
                    Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                        (response: DataResponse<ItemTypeAlbum>) in
                        if let itemType = response.result.value {
                            self.albums = itemType.albums
                            for item in (self.albums?.items)! {
                                self.allItems.append(item)
                                self.names.append(item.name!)
                                if (item.images?.indices.contains(2))! {
                                    if item.images?[2].url != nil {
                                        self.imagesTest.append((item.images?[2].url)!)
                                    }
                                }
                            }
                        }
                        
                        if self.names.count == 0 {
                            self.noResultView.isHidden = false
                        }else {
                            self.noResultView.isHidden = true
                        }
                        self.tableView.reloadData()
                    })
                }
                    
                else if type == "artist"{
                    Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                        (response: DataResponse<ItemTypeArtist>) in
                        if let itemType = response.result.value {
                            self.artists = itemType.artists
                            for item in (self.artists?.items)! {
                                self.allItems.append(item)
                                self.names.append(item.name!)
                            }
                        }
                        
                        if self.names.count == 0 {
                            self.noResultView.isHidden = false
                        }else {
                            self.noResultView.isHidden = true
                        }
                        self.tableView.reloadData()
                    })
                }
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Pas connecté à Spotify", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Se connecter", style: UIAlertActionStyle.default, handler: { action in
            self.showAuthSpotify()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAuthSpotify() {
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
        let newRootVC = UINavigationController(rootViewController: authVC)
        revealVC.pushFrontViewController(newRootVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "resultcell", for: indexPath) as! ResultSearchCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        if searchType == "artist" {
            cell.bindData(title: names[indexPath.row])
        } else {
            if imagesTest.indices.contains(indexPath.row) {
                cell.bindData(title: names[indexPath.row], imageURL: imagesTest[indexPath.row])
            } else {
                cell.bindData(title: names[indexPath.row])
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastElement = names.count - 1
        if indexPath.row == lastElement {
            if searchType == "track" {
                if tracks?.next != nil {
                    searchUrl = tracks?.next
                    requestResult(url: searchUrl!, type: searchType)
                }
            }
            else if searchType == "album" {
                if albums?.next != nil {
                    searchUrl = albums?.next
                    requestResult(url: searchUrl!, type: searchType)
                }
            }
            else if searchType == "artist" {
                if artists?.next != nil {
                    searchUrl = artists?.next
                    requestResult(url: searchUrl!, type: searchType)
                }

            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchType == "track" {
            let trackVC = TrackVC(nibName: TrackVC.className(), bundle: nil)
            trackVC.item = allItems[indexPath.row]
            navigationController?.pushViewController(trackVC, animated: true)
        }
        
        else if searchType == "album" {
            let albumVC = AlbumVC(nibName: AlbumVC.className(), bundle: nil)
            albumVC.url =  allItems[indexPath.row].href
            navigationController?.pushViewController(albumVC, animated: true)
        }
        
        else if searchType == "artist" {
            let artistVC = ArtistVC(nibName: ArtistVC.className(), bundle: nil)
            artistVC.artist =  allItems[indexPath.row]
            navigationController?.pushViewController(artistVC, animated: true)
        }
    }
    
    @IBAction func segmentedBarClicked(_ sender: Any) {
        names = []
        allItems = []
        imagesTest = []
        switch segmentedBar.selectedSegmentIndex {
            case 0:
                searchType = "track"
                searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
                requestResult(url: searchUrl!, type: searchType)
                self.tableView.reloadData()
                break;
            case 1:
                searchType = "album"
                searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
                requestResult(url: searchUrl!, type: searchType)
                self.tableView.reloadData()
                break;
            case 2:
                searchType = "artist"
                searchUrl = "https://api.spotify.com/v1/search?q=" + searchWordUpdated + "&type=" + searchType
                requestResult(url: searchUrl!, type: searchType)
                self.tableView.reloadData()
                break;
            default:
                break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

