//
//  RewardVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire

class RewardVC: UIViewController {
    
    var rewards = [Reward]()
    var user: User?
    let headers: HTTPHeaders = ["Accept": "application/json"]
    
    @IBOutlet weak var userGoldLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.edgesForExtendedLayout = []
        self.title = "Récompenses"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserInfoSaver().isAuth()!{
            self.requestUser()
        }
    }
    
    func requestUser() {
        let url = "http://mocnodeserv.hopto.org:80/users/username/" + UserInfoSaver().getUsername()!
        Alamofire.request(url, headers: headers).responseObject(completionHandler: {
            (response: DataResponse<User>) in
            if let user = response.result.value {
                self.user = user
                self.userGoldLabel.text = "Gold: \(String(describing: user.gold!))"
                self.requestReward()
            }
        })
    }
    
    func requestReward() {
        let url = "http://mocnodeserv.hopto.org:80/reward/range/0/" + String(describing: user!.gold!)
        Alamofire.request(url, headers: headers).responseArray(completionHandler: {
            (response: DataResponse<[Reward]>) in
            if let rewards = response.result.value {
                self.rewards = rewards
                self.tableView.reloadData()
            }
        })
    }
    
    func requestBuy(reward: Reward) {
        let url = "http://mocnodeserv.hopto.org:80/reward/give/" + UserInfoSaver().getUserIdMusicFinder()! + "/" + reward.id!
        
        Alamofire.request(url, method: .put, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                    let alert = UIAlertController(title: "Succès", message: "Récompense achetée !", preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                        UIAlertAction in
                        self.requestUser()
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                
            case .failure:
                let alert = UIAlertController(title: "Alert", message: "ERREUR achat récompense", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension RewardVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        } else {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        }
        let fullString = self.rewards[indexPath.row].title! + " (prix: \(String(describing: self.rewards[indexPath.row].goldToAccess!)))"
        cell.bindData(title: fullString)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Achat", message: "Voulez-vous acheter cette récompense ?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.requestBuy(reward: self.rewards[indexPath.row])
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}
