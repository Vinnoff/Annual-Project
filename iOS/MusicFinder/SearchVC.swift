//
//  SearchVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire

class SearchVC: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitClicked(_ sender: Any) {
        if (textField.text?.isEmpty)! {
            let alert = UIAlertController(title: "Oops !", message: "Écrivez un mot dans la barre de saisie avant", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let resultSearchVC = ResultSearchVC(nibName: ResultSearchVC.className(), bundle: nil)
            resultSearchVC.searchWord = textField.text!
            navigationController?.pushViewController(resultSearchVC, animated: true)
        }
        
    }
}
