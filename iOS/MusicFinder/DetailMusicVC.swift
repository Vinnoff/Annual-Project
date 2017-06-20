//
//  DetailMusicVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 26/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import AVFoundation

class DetailMusicVC: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    
    var count: Int = 0
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var url: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //url = NSURL(fileURLWithPath: )
        url = NSURL(string: "https://p.scdn.co/mp3-preview/df7aa7ccf074d5f2661a85ee443ce1f6782e3ef5?cid=null")
        playerItem = AVPlayerItem(url: url as! URL)
        player = AVPlayer(playerItem: playerItem)
        player = AVPlayer(url: url as! URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func playButtonTouched(_ sender: Any) {
        count += 1
        player?.play()
        self.playButton.setTitle("Pause", for: .normal)
        if (count == 2) {
            count = 0
            self.playButton.setTitle("Ecouter", for: .normal)
            player?.pause()
        }
    }

}
