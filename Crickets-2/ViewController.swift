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
    
    let audioEngine: AVAudioEngine? = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    

    var timer2 = Timer()

    
    @objc func timerFunction2(transcript: String) {
        print("triggered timer function")
        if transcript == "" {
                print("transcript is empty")
                   //playSound()
                //return transcript
               } else {
                print(transcript)
                   //recSpeech()
               }
        //return "what"
    }
    
    @objc func timerFunction(){
        print("timer function triggered")
    }
    
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

    @IBOutlet weak var awkward: UIButton!
    
    
    @IBAction func awkwardSilenceButtonClicked(_ sender: Any) {
        recSpeech()
        
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
    
    func recSpeech(){
        //_ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: false)
        
        //rewrite / refactor this function, create new rectask for each 5 seconds?
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let newResult = result {
                
                _ = newResult.bestTranscription.formattedString
                
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                        self.timerFunction2(transcript: newResult.bestTranscription.formattedString)
                        
                    })
                   
                    
                print("end of result if")
                //let pauseDuration = result.bestTranscription.averagePauseDuration
                //if formatted string = "" then chirp?
            } else if let error = error {
                print(error)
            }

        })
        
        //right here should re-create a new variable after 5 seconds and send it to a check
        
        //move device check into its own function, disable awkward silence button
        //if device check fails
        guard let deviceCheck = SFSpeechRecognizer() else { return }
        if !deviceCheck.isAvailable { return }
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
            print("cancelled previous rec task")
        }
        guard let node = audioEngine?.inputNode else { return }
        let recordingFormat = node.outputFormat(forBus: 0)
        
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in self.request.append(buffer)
        }
        
        audioEngine?.prepare()
        do {
            try audioEngine?.start()
            print("audio engine started")
        } catch {
            return print(error)
        }
        
    }
    

}

