//
//  ProfileVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 05/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire

class ProfileVC: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var goldLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var disconnectButton: UIButton!
    var user: User?
    var rewards = [Reward]()
    let headers: HTTPHeaders = ["Accept": "application/json"]
    var friends = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.edgesForExtendedLayout = []
        self.title = "Profil"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: SimpleCell.className(), bundle: nil), forCellReuseIdentifier: "cell")
        self.disconnectButton.layer.cornerRadius = 10.0
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(ProfileVC.longPress(longPressGestureRecognizer:)))
        longPress.minimumPressDuration = 1.0
        longPress.delegate = self
        tableView.addGestureRecognizer(longPress)
        
        self.requestUser()
    }
    
    func requestUser() {
        let url = "http://mocnodeserv.hopto.org:3000/users/username/" + UserInfoSaver().getUsername()!
        Alamofire.request(url, headers: headers).responseObject(completionHandler: {
            (response: DataResponse<User>) in
            if let user = response.result.value {
                self.user = user
                self.bindData()
                self.requestReward()
                self.requestFriend()
            }
        })
    }
    
    func requestReward() {
        for reward in (user?.rewards)! {
            let url = "http://mocnodeserv.hopto.org:3000/reward/id/" + reward
            Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                (response: DataResponse<Reward>) in
                if let rewardReceived = response.result.value {
                    self.rewards.append(rewardReceived)
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func requestFriend() {
        for friendId in (user?.friends)! {
            let url = "http://mocnodeserv.hopto.org:3000/users/id/" + friendId
            Alamofire.request(url, headers: headers).responseObject(completionHandler: {
                (response: DataResponse<User>) in
                if let user = response.result.value {
                    self.friends.append(user)
                }
                self.tableView.reloadData()
            })
        }
    }
    
    func bindData() {
        self.pseudoLabel.text = user?.username
        self.rankLabel.text = user?.rank?.title
        self.scoreLabel.text = "\(String(describing: user!.globalScore!))"
        self.goldLabel.text = "\(String(describing: user!.gold!))"
    }
    
    func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
        let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint) {
            if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
                if indexPath.section == 1 {
                    self.askDeleteFriend(index: indexPath.row)
                }
            }
        }
    }
    
    func askDeleteFriend(index: Int?) {
        if let id = self.friends[index!].id {
            let alert = UIAlertController(title: "Attention", message: "Voulez-vous supprimer cette utilisateur de votre liste ?", preferredStyle: UIAlertControllerStyle.alert)
            let yesAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.requestRemoveFriend(user: self.friends[index!], index: index!)
            }
            alert.addAction(yesAction)
            alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func requestRemoveFriend(user: User, index: Int) {
        let url = "http://mocnodeserv.hopto.org:3000/users/friend/" + UserInfoSaver().getUserIdMusicFinder()! + "/" + user.id!
        
        let headersMF: HTTPHeaders = ["Authorization": UserInfoSaver().getTokenMF()!,
                                      "Accept": "application/json"]
        
        Alamofire.request(url, method: .delete, encoding: JSONEncoding.default, headers: headersMF).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Succès", message: "\(String(describing: user.username!)) retiré(e) de votre liste ", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.friends.remove(at: index)
                    self.tableView.reloadData()
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                let alert = UIAlertController(title: "Alert", message: "Erreur suppression ami \(String(describing: response.response?.statusCode))", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func disconnectedClicked(_ sender: Any) {
        let headersMF: HTTPHeaders = ["Authorization": UserInfoSaver().getTokenMF()!,
                                      "Accept": "application/json"]
        let url = "http://mocnodeserv.hopto.org:3000/auth/logout"
        
        Alamofire.request(url, method: .post, encoding: JSONEncoding.default, headers: headersMF).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Succès", message: "Déconnexion réussie !", preferredStyle: UIAlertControllerStyle.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    UserInfoSaver().disconnectAccount()
                    self.showHomeVC()
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                let alert = UIAlertController(title: "Alert", message: "Erreur déconnexion \(String(describing: response.response?.statusCode))", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func showHomeVC() {
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        let homeVC = Home2VC(nibName: Home2VC.className(), bundle: nil)
        let newRootVC = UINavigationController(rootViewController: homeVC)
        revealVC.pushFrontViewController(newRootVC, animated: true)
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let count = user?.rewards?.count {
                return count
            }
            return 1
        }
        else {
            if let count = user?.friends?.count {
                return count
            }
            return 1
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
            if self.rewards.indices.contains(indexPath.row) {
                cell.bindData(title: self.rewards[indexPath.row].title)
            } else {
                cell.bindData(title: "")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SimpleCell
            if indexPath.row % 2 == 0 {
                cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
            } else {
                cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
            }
            if self.friends.indices.contains(indexPath.row) {
                cell.bindData(title: self.friends[indexPath.row].username)
            } else {
                cell.bindData(title: "")
            }
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = UIColor(red: 228, green: 74, blue: 102)
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor(red: 211, green: 232, blue: 225)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Récompense(s)"
        } else {
            return "Ami(s)"
        }
    }
}
