//
//  ViewController.swift
//  Crickets-2
//
//  Created by Kyle Braden on 10/8/19.
//  Copyright © 2019 Kyle Braden. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    let url = URL(fileURLWithPath: Bundle.main.path(forResource: "chirp.wav", ofType: nil)!)
    var player: AVAudioPlayer?
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    

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
        requestSpeechAuth()
    }

    
    func playSound() {

        if player?.isPlaying == true {
            print("player is playing - pausing..")
            player?.pause()
        } else {
            player?.numberOfLoops = 1000
            player?.play()
        }
        
    }
    
    func requestSpeechAuth() {
        SFSpeechRecognizer.requestAuthorization { [unowned self] authStatus in
            DispatchQueue.main.async {
                if authStatus == .authorized {
                    print("authorization complete")
                } else {
                    print("authorization declined")
                }
            }
        }
    }
    
    func checkForAudioTranscription(){
        
    }

}

