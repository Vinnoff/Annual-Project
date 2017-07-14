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
        self.navigationItem.leftBarButtonItem?.tintColor =  UIColor(red: 228, green: 74, blue: 102)
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 211, green: 232, blue: 225)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 228, green: 74, blue: 102)]
    }
    
    func addGestureMenu() {
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
   
}
