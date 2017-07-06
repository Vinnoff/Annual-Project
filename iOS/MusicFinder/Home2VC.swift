//
//  Home2VC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 06/07/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit

class Home2VC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var imageArray = [UIImage]()
    
    @IBOutlet weak var controlePage: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarItem()
        self.addGestureMenu()
        self.navigationItem.leftBarButtonItem?.tintColor =  UIColor.darkGray
        
        self.title = "Music Finder"
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        controlePage.currentPage = Int(pageNumber)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
