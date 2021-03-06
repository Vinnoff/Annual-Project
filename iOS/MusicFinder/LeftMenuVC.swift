//
//  LeftMenuVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 25/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import SWRevealViewController

class LeftMenuVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var mainViewController: UIViewController!
    var items: [String] = ["Accueil","Se connecter", "Quizz", "Rechercher", "Upload Playlist", "Creer Playlist", "Voir mes playlists", "Récompenses", "Ajouter un ami", "Classement"]
    var ico: [String] = ["ico_home", "ico_profile", "ico_quizz", "ico_search", "ico_upload", "ico_addplaylist", "ico_playlist", "ico_reward", "ico_addfriend", "ico_ranking"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        tableView.register(UINib(nibName: LeftMenuCell.className(), bundle: nil), forCellReuseIdentifier: "leftmenucell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "leftmenucell", for: indexPath) as! LeftMenuCell
        if UserInfoSaver().isAuth()! && self.items[indexPath.row] == "Se connecter" {
            cell.bindData(title: "Profil", imageName: self.ico[indexPath.row])
        } else {
            cell.bindData(title: self.items[indexPath.row], imageName: self.ico[indexPath.row])
        }
        if indexPath.row % 2 == 0 {
            cell.view.backgroundColor = UIColor(red: 194, green: 214, blue: 208)
        } else {
            cell.view.backgroundColor = UIColor(red: 211, green: 232, blue: 225)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        
        switch (indexPath.row) {
        case 0:
            let homeVC = Home2VC(nibName: Home2VC.className(), bundle: nil)
            let newRootVC = UINavigationController(rootViewController: homeVC)
            revealVC.pushFrontViewController(newRootVC, animated: true)
            
        case 1:
            if UserInfoSaver().isAuth()! {
                let profileVC = ProfileVC(nibName: ProfileVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: profileVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }
            
        case 2:
            if UserInfoSaver().isAuth()! {
                let listQuizzVC = ListQuizzVC(nibName: ListQuizzVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: listQuizzVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }
            
        case 3:
            if UserInfoSaver().isAuth()! {
                let searchVC = SearchVC(nibName: SearchVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: searchVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }

            
        case 4:
            if UserInfoSaver().isAuth()! {
                let uploadPlaylistVC = UploadPlaylistSpotifyVC(nibName: UploadPlaylistSpotifyVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: uploadPlaylistVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }
        case 5:
            if UserInfoSaver().isAuth()! {
                let createPlaylistVC = CreatePlaylistVC(nibName: CreatePlaylistVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: createPlaylistVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }
            
        case 6:
            if UserInfoSaver().isAuth()! {
                let listPlaylistVC = ListPlaylistVC(nibName: ListPlaylistVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: listPlaylistVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }
            
        case 7:
            if UserInfoSaver().isAuth()! {
                let rewardVC = RewardVC(nibName: RewardVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: rewardVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }
        
        case 8:
            if UserInfoSaver().isAuth()! {
                let addFriendVC = AddFriendVC(nibName: AddFriendVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: addFriendVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }
        case 9:
            if UserInfoSaver().isAuth()! {
                let rankingVC = RankingVC(nibName: RankingVC.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: rankingVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            } else {
                let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
                let newRootVC = UINavigationController(rootViewController: authVC)
                revealVC.pushFrontViewController(newRootVC, animated: true)
            }
        default:
            break
        }
    }

}
