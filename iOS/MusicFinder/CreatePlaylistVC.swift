//
//  CreatePlaylistVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 08/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire

class CreatePlaylistVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if UserInfoSaver().isAuth()! {
            if let session = UserInfoSaver().getSessionSpotify() {
                let idUser = UserInfoSaver().getUserIdMusicFinder()
                if textField.text != nil{
                    let headers: HTTPHeaders = [
                        "Accept": "application/json"
                    ]
                    let parameters = [
                        "title": textField.text as! String,
                        "isPublic" : "true",
                        "Creator" : idUser
                        ] as [String : Any]
                    
                    Alamofire.request("http://mocnodeserv.hopto.org:3000/playlist/", method: .post, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                        switch response.result {
                        case .success:
                            print("SUCCESS")
                            let alert = UIAlertController(title: "Alert", message: "Ajouté avec succes", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            
                        case .failure:
                            print("ERROR")
                            print(response.response?.statusCode)
                            let alert = UIAlertController(title: "Alert", message: "ERREUR", preferredStyle: UIAlertControllerStyle.alert)
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

}
