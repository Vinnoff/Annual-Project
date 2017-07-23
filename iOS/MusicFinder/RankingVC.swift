//
//  RankingVC.swift
//  MusicFinder
//
//  Created by OFFROY Vincent on 23/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire

class RankingVC: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    let headers: HTTPHeaders = ["Accept": "application/json"]
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.edgesForExtendedLayout = []
        self.title = "Classement"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.tableView.reloadData()
        
        self.requestUser()
        self.requestReward()
    }
    
    func requestReward() {
        let url = "http://mocnodeserv.hopto.org:3000/users/sorted/0/5"
        Alamofire.request(url, headers: headers).responseArray(completionHandler: {
            (response: DataResponse<[User]>) in
            if let users = response.result.value {
                self.users = users
                self.tableView.reloadData()
            }
        })
    }
    
    func requestUser() {
        let url = "http://mocnodeserv.hopto.org:3000/users/username/" + UserInfoSaver().getUsername()!
        Alamofire.request(url, headers: headers).responseObject(completionHandler: {
            (response: DataResponse<User>) in
            if let user = response.result.value {
                self.scoreLabel.text = "Votre score: \(String(describing: (user.globalScore)!))"
                self.requestReward()
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension RankingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        let fullString = self.users[indexPath.row].username! + " (Score: \(String(describing: (self.users[indexPath.row].globalScore)!)))"
        cell.bindData(title: fullString)
        return cell
    }
    
}
