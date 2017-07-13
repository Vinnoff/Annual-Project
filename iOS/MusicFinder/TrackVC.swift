//
//  TrackVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 15/06/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import AVFoundation

class TrackVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    public var item: Item?
    public var track: Track?
    private var count: Int = 0
    private var player: AVPlayer?
    private var playerItem: AVPlayerItem?
    private var playerUrl: NSURL?
    public var imageUrlFromAlbumVC: String?
    public var album: Album?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.layer.cornerRadius = 5.0
        
        if item != nil {
            titleLabel.text = item?.name
            
            if let name = item?.album?.name {
                albumLabel.text = name
            }
            else if let name = album?.name {
                albumLabel.text = name
            }
            
            
            if let imageURL = item?.album?.images?[1].url {
                let url = URL(string: imageURL)
                let data = try? Data(contentsOf: url!)
                coverImageView.image = UIImage(data: data!)
            }
                
            else if !(album?.images?.isEmpty)! {
                if let imageURL = album?.images?[1].url {
                    let url = URL(string: imageURL)
                    let data = try? Data(contentsOf: url!)
                    coverImageView.image = UIImage(data: data!)
                } else {
                    coverImageView.image = nil
                }
            }
            else {
                coverImageView.image = nil
            }
            
            //Player
            if let preview = item?.preview_url {
                playerUrl = NSURL(string: (preview))
                playerItem = AVPlayerItem(url: playerUrl! as URL)
                player = AVPlayer(playerItem: playerItem)
                player = AVPlayer(url: playerUrl! as URL)
            } else {
                playButton.isEnabled = false
                playButton.setTitle("Pas de preview", for: .disabled)
            }
        }
        
        else if track != nil {
            titleLabel.text = track?.name
            
            if let name = track?.album?.name {
                albumLabel.text = name
            }
            else if let name = album?.name {
                albumLabel.text = name
            }
            
            
            if let imageURL = track?.album?.images?[1].url {
                let url = URL(string: imageURL)
                let data = try? Data(contentsOf: url!)
                coverImageView.image = UIImage(data: data!)
            }
                
            else if !(album?.images?.isEmpty)! {
                if let imageURL = album?.images?[1].url {
                    let url = URL(string: imageURL)
                    let data = try? Data(contentsOf: url!)
                    coverImageView.image = UIImage(data: data!)
                } else {
                    coverImageView.image = nil
                }
            }
            else {
                coverImageView.image = nil
            }
            
            //Player
            playerUrl = NSURL(string: (track?.preview_url)!)
            playerItem = AVPlayerItem(url: playerUrl! as URL)
            player = AVPlayer(playerItem: playerItem)
            player = AVPlayer(url: playerUrl! as URL)
        }
    }

 
    @IBAction func playClicked(_ sender: Any) {
        count += 1
        player?.play()
        self.playButton.setTitle("Pause", for: .normal)
        if (count == 2) {
            count = 0
            self.playButton.setTitle("Ecouter", for: .normal)
            player?.pause()
        }
    }
    
    @IBAction func addClicked(_ sender: Any) {
        if item?.preview_url == nil && track?.preview_url == nil {
            let alert = UIAlertController(title: "Alerte", message: "La musique n'a pas d'extrait donc ne peut pas être ajoutée", preferredStyle: UIAlertControllerStyle.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)

        }
        else if item != nil && track == nil{
            let listPlaylistVC = ListPlaylistVC(nibName: ListPlaylistVC.className(), bundle: nil)
            listPlaylistVC.trackItem = item
            listPlaylistVC.fromUser = true
            navigationController?.pushViewController(listPlaylistVC, animated: true)
        } else if track != nil && item == nil {
            let listPlaylistVC = ListPlaylistVC(nibName: ListPlaylistVC.className(), bundle: nil)
            listPlaylistVC.track = track
            listPlaylistVC.fromUser = true
            navigationController?.pushViewController(listPlaylistVC, animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
