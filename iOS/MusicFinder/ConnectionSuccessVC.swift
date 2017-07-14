//
//  ConnectionSuccessVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 09/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import SWRevealViewController
import Alamofire

class ConnectionSuccessVC: UIViewController {

    @IBOutlet weak var label: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserInfoSaver().isAuth()! {
            label.text = "Connexion réussie"
        } else {
            label.text = "Erreur connexion"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func buttonClicked(_ sender: Any) {        
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        let homeVC = Home2VC(nibName: Home2VC.className(), bundle: nil)
        homeVC.authSuccess = true
        let newRootVC = UINavigationController(rootViewController: homeVC)
        revealVC.pushFrontViewController(newRootVC, animated: true)
    }
}
