//
//  ViewController.swift
//  Crickets-2
//
//  Created by Kyle Braden on 10/8/19.
//  Copyright © 2019 Kyle Braden. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    let url = URL(fileURLWithPath: Bundle.main.path(forResource: "chirp.wav", ofType: nil)!)
    var player: AVAudioPlayer?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        player = try! AVAudioPlayer(contentsOf: url)
        playSound()
    }
    
    @IBOutlet weak var chirp: UIButton! 
//        didSet {
//            chirp.setBackgroundImage(UIImage(named: "cricket"), for: .normal)
//        }
    
    
    @IBAction func chirpButtonClicked(_ sender: Any) {
        playSound()
    }
    

    
    
    
    func playSound() {

        if player?.isPlaying == true {
            print("farts")
            player?.pause()
        } else {
            player?.numberOfLoops = 1000
            player?.play()
        }
        
    }

}

