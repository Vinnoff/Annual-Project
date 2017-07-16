//
//  AddFriendVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 16/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire

class AddFriendVC: UIViewController {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let headers: HTTPHeaders = ["Accept": "application/json"]
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func requestSearch() {
        func requestTracks() {
            let url = "http://mocnodeserv.hopto.org:3000/pl"
            Alamofire.request(url, headers: headers).responseArray { (response: DataResponse<[User]>) in
                if let users = response.result.value {
                    self.users = users
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func requestAddUser() {
        
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    ///users/friend/:idDuMec
}


