//
//  UIViewController.swift
//  MusicFinder
//
//  Created by TRAING Serey on 26/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//
import UIKit
import SWRevealViewController
extension UIViewController {
    
    func setNavigationBarItem() {
        let revealController = SWRevealViewController()
        revealController.panGestureRecognizer()
        revealController.tapGestureRecognizer()
        let menuIcon = UIImage(named: "ic_menu")
        let leftItem = UIBarButtonItem(image: menuIcon, style: .plain, target: revealController, action: #selector(revealController.revealToggle(_:)))
        self.navigationItem.leftBarButtonItem = leftItem
    }
    
   
}
