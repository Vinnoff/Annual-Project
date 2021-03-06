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
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
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
        self.wrongLabel.isHidden = true
        self.submitButton.layer.cornerRadius = 10.0
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
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Retour", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailMusicVC.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
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
        self.timerLabel.text = "\(30 - counterTimerScore)"
    }
    
    func checkAnswer(userAnswer: String, answer: String) {
        if userAnswer == answer {
            self.updateScore()
            self.timerScore?.invalidate()
            self.timer?.invalidate()
            let alert = UIAlertController(title: "Bravo !", message: "Bonne réponse \n Score: \(self.score)", preferredStyle: UIAlertControllerStyle.alert)
            let closeAction = UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default) {
                UIAlertAction in
                self.indexMusic += 1
                self.wrongLabel.isHidden = true
                self.changeMusic()
            }
            alert.addAction(closeAction)
            self.present(alert, animated: true, completion: nil)
        } else {
            self.wrongLabel.isHidden = false
        }
    }
    
    func updateScore() {
        self.score += (Int(delay) - counterTimerScore)
    }
    
    func requestSendScore() {
        var idScore: String?
        for score in (quizz?.scores)! {
            if score.playerId == UserInfoSaver().getUserIdMusicFinder() {
                idScore = score.score
            }
        }
        
        let url = "http://mocnodeserv.hopto.org:80/game/score/" + idScore!
        let parameters = [
            "scoreInGame": score,
            "isFinished": true
            ] as [String : Any]
        
        Alamofire.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: headers).validate(statusCode: 200..<300).responseData(completionHandler: { (response) in
            switch response.result {
            case .success:
                let alert = UIAlertController(title: "Félicitations !", message: "La partie est terminé \n Score final: \(self.score)", preferredStyle: UIAlertControllerStyle.alert)
                let closeAction = UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(closeAction)
                self.present(alert, animated: true, completion: nil)
                
            case .failure:
                let alert = UIAlertController(title: "Alert", message: "Erreur envoie score \(response.response?.statusCode)", preferredStyle: UIAlertControllerStyle.alert)
                let closeAction = UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default) {
                    UIAlertAction in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(closeAction)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    func back(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Attention", message: "Voulez-vous arrêter ?", preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "Oui", style: UIAlertActionStyle.default) {
            UIAlertAction in
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(UIAlertAction(title: "Non", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if !(textField.text?.isEmpty)! {
            let userAnswer = textField.text?.lowercased()
            let answer = quizz?.tracks?[indexMusic].title?.lowercased()
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
