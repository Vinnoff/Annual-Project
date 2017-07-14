//
//  DetailMusicVC.swift
//  MusicFinder
//
//  Created by TRAING Serey on 26/03/2017.
//  Copyright © 2017 TRAING Serey. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class DetailMusicVC: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var quizz: Quizz?
    var timer: Timer?
    var timerScore: Timer?
    var count: Int = 0
    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    let delay = 30.0
    let delayScore = 1.0
    var indexMusic = 0
    var score = 0
    var counterTimerScore = 0
    let headers: HTTPHeaders = [
        "Accept": "application/json"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        let alert = UIAlertController(title: "Attention", message: "Êtes-vous prêt ?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "GO !", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.createTimer()
            self.changeMusic()
        }
        let closeAction = UIAlertAction(title: "Non ", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
        
        self.titleLabel.text = "Musique \(indexMusic + 1) / \(String(describing: (quizz?.tracks?.count)!))"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timerScore?.invalidate()
        self.timer?.invalidate()
        self.player?.pause()
        self.player = nil
    }
    
    func initPlayer(url: String?) {
        let url = NSURL(string: url!)
        self.playerItem = AVPlayerItem(url: url! as URL)
        self.player = AVPlayer(playerItem: playerItem)
        self.player = AVPlayer(url: url! as URL)
        self.player?.play()
    }
    
    func createTimer() {
        self.counterTimerScore = 0
        self.timer?.invalidate()
        self.timerScore?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: delay, target:self, selector: #selector(musicNotFound), userInfo: nil, repeats: true)
        self.timerScore = Timer.scheduledTimer(timeInterval: delayScore, target:self, selector: #selector(updateCounterScore), userInfo: nil, repeats: true)
    }
    
    func changeMusic() {
        if self.indexMusic < (quizz?.tracks?.count)! {
            self.titleLabel.text = "Musique \(indexMusic + 1) / \(String(describing: (quizz?.tracks?.count)!))"
            self.textField.text = ""
            self.createTimer()
            self.initPlayer(url: quizz?.tracks?[indexMusic].url)
        } else {
            self.requestSendScore()
        }
    }
    
    func musicNotFound() {
        self.indexMusic += 1
        self.changeMusic()
    }
    
    func updateCounterScore() {
        self.counterTimerScore += 1
    }
    
    func checkAnswer(userAnswer: String, answer: String) {
        if userAnswer == answer {
            self.updateScore()
            let alert = UIAlertController(title: "Bravo !", message: "Bonne réponse \n Score: \(self.score)", preferredStyle: UIAlertControllerStyle.alert)
            let closeAction = UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.indexMusic += 1
                self.changeMusic()
            }
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            print("FAUX")
        }
    }
    
    func updateScore() {
        self.score += (Int(delay) - counterTimerScore) * 100
    }
    
    func requestSendScore() {
        var idScore: String?
        for score in (quizz?.scores)! {
            if score.playerId == UserInfoSaver().getUserIdMusicFinder() {
                idScore = score.id
            }
        }
        
        let url = "http://mocnodeserv.hopto.org:3000/game/score/" + idScore!
        let parameters = [
            "scoreInGame": score,
            "isFinished": true
            ] as [String : Any]
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                print("SUCCESS")
                let alert = UIAlertController(title: "Félicitations !", message: "La partie est terminé \n Score final: \(self.score)", preferredStyle: UIAlertControllerStyle.alert)
                let closeAction = UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(closeAction)
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                print("ERROR")
                print(response.response?.statusCode)
                let alert = UIAlertController(title: "Alert", message: "Erreur envoie score", preferredStyle: UIAlertControllerStyle.alert)
                let closeAction = UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(closeAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if !(textField.text?.isEmpty)! {
            let userAnswer = textField.text?.lowercased()
            let answer = quizz?.tracks?[indexMusic].title?.lowercased()
            print(userAnswer! + " " + answer!)
            self.checkAnswer(userAnswer: userAnswer!, answer: answer!)
        } else {
            let alert = UIAlertController(title: "Oops !", message: "Écrivez un mot dans la barre de saisie avant", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
