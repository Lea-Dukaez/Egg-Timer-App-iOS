//
//  ViewController.swift
//  My Egg Timer
//
//  Created by Léa on 01/04/2020.
//  Copyright © 2020 Lea Dukaez. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var alarmPlayer: AVAudioPlayer?
    
    var countTimer:Timer!
    var count: Double = 0.0
    let timer: [Double] = [300, 480, 720]
    var progressPoint: Double = 0
    var progress: Double = 0
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var ProgressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ProgressBar.progress = 0.0
    }

    @IBAction func ButtonPressed(_ sender: UIButton) {
        let hardness = sender.titleLabel!.text!
        TitleLabel.text = hardness
        switch hardness {
        case "Soft":
            count = timer[0]
            progressPoint = 1/count
        case "Medium":
            count = timer[1]
            progressPoint = 1/count
        default:
            count = timer[2]
            progressPoint = 1/count
        }
        self.countTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        if(count > 0) {
            progress += progressPoint
            count -= 1
            ProgressBar.progress = Float(progress)
        } else {
            playSound()
            TitleLabel.text = "READY !"
            countTimer.invalidate()
            Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(updateQuestion), userInfo: nil, repeats: false)
        }
    }
    
    @objc func updateQuestion(){
        TitleLabel.text = "How do you like your eggs ?"
        progress = 0.0
        ProgressBar.progress =  0.0
        
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "alarm", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            alarmPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            guard let player = alarmPlayer else { return }

            player.play()
            
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) {_ in
                player.stop()
            }

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
}









