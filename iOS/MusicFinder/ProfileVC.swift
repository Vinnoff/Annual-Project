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
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        let urlInfoAccount = "https://api.spotify.com/v1/me"
        let headers: HTTPHeaders = [
            //"Authorization": "Bearer " + session.accessToken,
            "Accept": "application/json"
        ]
    
        let parameters = [
            "username": "serey",
            ] as [String : Any]
        
        
        Alamofire.request("http://mocnodeserv.hopto.org:3000/song/", method: .get, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                print("SUCCESS")
                break
                
            case .failure: break

            }
        })
        
        requestDetailUserSpotify(url: urlInfoAccount)
    }
    
    func requestDetailUserSpotify(url: String) {
        let token: String?
        
        if let session = UserInfoSaver().getSessionSpotify() {
            token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + token!,
                                        "Accept": "application/json"]
            print(headers)
            Alamofire.request(url, headers: headers).responseJSON(completionHandler: { (response) in
                if let JSON = response.result.value {
                    print(JSON)
                }
            })
        }
    }
    @IBAction func disconnectedClicked(_ sender: Any) {
        UserInfoSaver().disconnectAccount()
        
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        let homeVC = Home2VC(nibName: Home2VC.className(), bundle: nil)
        let newRootVC = UINavigationController(rootViewController: homeVC)
        revealVC.pushFrontViewController(newRootVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
