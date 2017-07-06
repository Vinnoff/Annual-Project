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

class ProfileVC: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        
        let headers: HTTPHeaders = [
            //"Authorization": "Bearer " + session.accessToken,
            "Accept": "application/json"
        ]
        
        let parameters = [
            "username": "serey",
            
            ] as [String : Any]
        
        
        /*Alamofire.request("https://api.spotify.com/v1/users/alkrox/playlists", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success: break
                
            case .failure: break

            }
        })*/
    }

    @IBAction func disconnectedClicked(_ sender: Any) {
        UserInfoSaver().disconnectAccount()
        
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        let homeVC = HomeVC(nibName: HomeVC.className(), bundle: nil)
        let newRootVC = UINavigationController(rootViewController: homeVC)
        revealVC.pushFrontViewController(newRootVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
