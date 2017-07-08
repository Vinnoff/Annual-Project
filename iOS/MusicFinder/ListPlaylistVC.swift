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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        requestPlaylists()
        tableView.reloadData()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestPlaylists() {
        let url = "http://mocnodeserv.hopto.org:3000/playlist/"
        
        /*Alamofire.request(url, method: .get).responseObject(completionHandler: {
            (response: DataResponse<[Playlist?]>) in
            
            print(response.result.value)
            self.playlists = response.result.value
        })*/
        
        Alamofire.request(url).responseArray { (response: DataResponse<[Playlist]>) in
            
            if let playlists = response.result.value {
                self.playlists = playlists
                self.tableView.reloadData()

            }
        }
            

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = playlists[indexPath.row]?.title
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
}
