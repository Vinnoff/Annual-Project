//
//  CreatePlaylistVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 08/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire
import SWRevealViewController

class CreatePlaylistVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.title = "Créer une playlist"
        self.submitButton.layer.cornerRadius = 10.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showSearchVC() {
        var revealVC: SWRevealViewController
        revealVC = self.revealViewController()
        let searchVC = SearchVC(nibName: SearchVC.className(), bundle: nil)
        let newRootVC = UINavigationController(rootViewController: searchVC)
        revealVC.pushFrontViewController(newRootVC, animated: true)
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if UserInfoSaver().isAuth()! {
            let idUser = UserInfoSaver().getUserIdMusicFinder()
            if textField.text != nil{
                let headersMF: HTTPHeaders = ["Authorization": UserInfoSaver().getTokenMF()!,
                                              "Accept": "application/json"]
                let parameters = [
                    "title": textField.text as! String,
                    "isPublic" : "true",
                    "Creator" : idUser
                    ] as [String : Any]
                
                let url = "http://mocnodeserv.hopto.org:3000/playlist/" + UserInfoSaver().getUserIdMusicFinder()!
                Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headersMF).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                    switch response.result {
                    case .success:
                        let alert = UIAlertController(title: "Succès", message: "Ajouté avec succès", preferredStyle: UIAlertControllerStyle.alert)
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                            UIAlertAction in
                            self.showSearchVC()
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                        
                    case .failure:
                        let alert = UIAlertController(title: "Alert", message: "ERREUR creation \(response.response?.statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            } else {
                print("erreur textfield")
            }
        }
    }

}
