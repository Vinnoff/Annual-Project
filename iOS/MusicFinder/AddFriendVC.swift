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
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.edgesForExtendedLayout = []
        self.title = "Ajouter un ami"
        self.searchButton.layer.cornerRadius = 10.0
        self.tableView.register(UINib(nibName: "SimpleCell", bundle: nil), forCellReuseIdentifier: "cell")
    }

    func requestSearch(word: String) {
        let url = "http://mocnodeserv.hopto.org:3000/users/userNameResearch/" + word.lowercased()
        Alamofire.request(url, headers: headers).responseArray { (response: DataResponse<[User]>) in
            if let users = response.result.value {
                for user in users {
                    if !(user.id == UserInfoSaver().getUserIdMusicFinder()) {
                        self.users.append(user)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    func requestAddUser(user: User) {
        let url = "http://mocnodeserv.hopto.org:3000/users/friend/" + UserInfoSaver().getUserIdMusicFinder()! + "/" + user.id!
        let headersMF: HTTPHeaders = ["Authorization": UserInfoSaver().getTokenMF()!,
                                      "Accept": "application/json"]
        
        Alamofire.request(url, method: .put, encoding: JSONEncoding.default, headers: headersMF).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Succès", message: "\(String(describing: user.username!)) ajouté(e) à votre liste ", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                if response.response?.statusCode == 401 {
                    let alert = UIAlertController(title: "Oops !", message: "Vous êtes déjà amis", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Alert", message: "Erreur ajout ami \(String(describing: response.response?.statusCode))", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        if (usernameTextfield.text?.isEmpty)! {
            let alert = UIAlertController(title: "Erreur", message: "Ecrivez un pseudo avant", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.requestSearch(word: usernameTextfield.text!)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AddFriendVC : UITableViewDelegate, UITableViewDataSource {
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
        cell.bindData(title: self.users[indexPath.row].username)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Ajout", message: "Voulez-vous ajouter \(String(describing: self.users[indexPath.row].username!)) en ami ?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.requestAddUser(user: self.users[indexPath.row])
        }
        let closeAction = UIAlertAction(title: "Non ", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
    }
}


