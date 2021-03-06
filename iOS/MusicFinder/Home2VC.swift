//
//  Home2VC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 06/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import Alamofire
import SWRevealViewController

class Home2VC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var imageArray = [UIImage]()
    var authSuccess: Bool?
    @IBOutlet weak var controlePage: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 211, green: 232, blue: 225)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 228, green: 74, blue: 102)]
        
        self.title = "Music Finder"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        scrollView.frame = view.frame
        imageArray = [UIImage(named: "home1")!, UIImage(named: "home2")!]
        controlePage.numberOfPages = imageArray.count
        for i in 0..<imageArray.count {
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            imageView.contentMode = .scaleAspectFit
            let xPosition = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: xPosition, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
            scrollView.contentSize.width = scrollView.frame.width * CGFloat(i + 1)
            scrollView.addSubview(imageView)
            scrollView.delegate = self
        }
        
        if authSuccess != nil {
            requestUserMusicFinder()
        }
        
        if UserInfoSaver().isAuth()! {
            self.saveInfoUser()
        }
    }
    
    func requestUserMusicFinder() {
        if UserInfoSaver().isAuth()!{
            
            if let username = UserInfoSaver().getUsername() {
                let headers: HTTPHeaders = [
                    "Accept": "application/json"
                ]
                let url = "http://mocnodeserv.hopto.org:80/users/username/" + username
                Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                    if response.response?.statusCode == 204 {
                        let url = "http://mocnodeserv.hopto.org:80/users/"
                        let parameters = [
                            "userName" : username
                            
                            ] as [String : Any]
                        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default,headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
                            if response.response?.statusCode == 200 {
                                self.saveInfoUser()
                            }
                        })
                    } else if response.response?.statusCode == 200 {
                        self.saveInfoUser()
                    }
                })
            }
        }
    }

    func saveInfoUser() {
        UserInfoSaver().saveInfoUser()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        controlePage.currentPage = Int(pageNumber)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
