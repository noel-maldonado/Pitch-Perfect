//
//  recordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Noel Maldonado on 4/12/20.
//  Copyright © 2020 Noel Maldonado. All rights reserved.
//
  

import UIKit
import AVFoundation

class recordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        //Dispose of any resources that can be recreated
//    }
    
    @IBAction func recordAudio(_ sender: Any) {
        recordingLabel.text = "Recording in Progress"
        stopRecordingButton.isEnabled = true
        recordButton.isEnabled = false
        //gets the directory path and stores as a String in the Document Directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        //
        let recordingName = "recordingVoice.wav"
        //
        let pathArray = [dirPath, recordingName]
        //
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //
        let session = AVAudioSession.sharedInstance()
        //
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        //
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        recordButton.isEnabled = true
        stopRecordingButton.isEnabled = false
        recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)

    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
    
        } else {
            print("recording was not successful")
        }
    
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //checks segue identifier before running code inside the block
        if segue.identifier == "stopRecording" {
            //grab the destination ViewController
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            // grabs the sender URL from audioRecorderDidFinishRecording method
            let recordedAudioURL = sender as! URL
            // sets the recordedAudioURL and save it in the PlaySoundsViewController recordAudioURL 
            playSoundsVC.recordAudioURL = recordedAudioURL
        }
    }
    
}

