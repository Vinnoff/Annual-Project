//
//  HomeVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 25/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import SWRevealViewController
import iCarousel
import Alamofire

class HomeVC: UIViewController, iCarouselDelegate, iCarouselDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var carouselView: iCarousel!
    var numbers = [1,2,3]
    
    
    typealias JSONStandard = [String: AnyObject]
    let userDefaults = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        carouselView.delegate = self
        carouselView.dataSource = self
        carouselView.type = .linear
        
        self.title = "Home"
        self.setNavigationBarItem()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        carouselView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return numbers.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let tempView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
             tempView.backgroundColor = UIColor.red
        }
        else {
            tempView.backgroundColor = UIColor.blue
        }
        
        return tempView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        /*if option == iCarouselOption.spacing {
            return value * 2.0
        }*/
        return value * 1.3
    }

    
    func requestPlaylist(url: String) {
        if let session = UserInfoSaver().isAuthenticatedSpotify() {
            //token = session.accessToken
            let headers: HTTPHeaders = ["Authorization": "Bearer " + session.accessToken!]
            Alamofire.request(url, headers: headers).responseJSON(completionHandler: { (response) in
                if let JSON = response.result.value {
                    print(JSON)
                }
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var urlPlaylist = "https://api.spotify.com/v1/users/alkrox/playlists"
        //requestPlaylist(url: urlPlaylist)
    }
    
    
}

/*extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}*/


