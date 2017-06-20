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
    var listGenreQuizz: ListGenreQuizzVC!
    var items: [String] = ["Home","Auth Spotify", "Quizz", "Search"]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blue
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

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
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell")! as UITableViewCell
        cell.textLabel?.text = self.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        
        switch (indexPath.row) {
        case 0:
            let homeVC = HomeVC(nibName: HomeVC.className(), bundle: nil)
            let newRootVC = UINavigationController(rootViewController: homeVC)
            revealVC.pushFrontViewController(newRootVC, animated: true)
            
        case 1:
            let authVC = AuthOtherAccount(nibName: AuthOtherAccount.className(), bundle: nil)
            let newRootVC = UINavigationController(rootViewController: authVC)
            revealVC.pushFrontViewController(newRootVC, animated: true)
        case 2:
            let listGenreVC = ListGenreQuizzVC(nibName: ListGenreQuizzVC.className(), bundle: nil)
            let newRootVC = UINavigationController(rootViewController: listGenreVC)
            revealVC.pushFrontViewController(newRootVC, animated: true)
            
        case 3:
            let searchVC = SearchVC(nibName: SearchVC.className(), bundle: nil)
            let newRootVC = UINavigationController(rootViewController: searchVC)
            revealVC.pushFrontViewController(newRootVC, animated: true)
            
        default:
            break
        }
    }

}
