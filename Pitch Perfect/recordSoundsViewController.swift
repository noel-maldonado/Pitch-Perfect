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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(recording: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(recording: true)
        //gets the directory path and stores as a String in the Document Directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        // names the file
        let recordingName = "recordingVoice.wav"
        // creates an array with the path and name
        let pathArray = [dirPath, recordingName]
        //creates an filepath  URL using the pathArray while seperating
        let filePath = URL(string: pathArray.joined(separator: "/"))
        //creates a audio session
        let session = AVAudioSession.sharedInstance()
        // sets the audio session category for recording and playback. as well as putitng the options to play the audio from the sessions defaults to the bult-inspeaker instead of the receiver
        try! session.setCategory(AVAudioSession.Category.playAndRecord, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        //initializes and returns an audio recorder; provides audio recording capapbility
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        //makes this instance a delegate of audioRecorder
        audioRecorder.delegate = self
        //enable audio-level metering; it is by default false
        audioRecorder.isMeteringEnabled = true
        //creates an audio file and prepares the system for recording; can be called implicitly by .record()
        audioRecorder.prepareToRecord()
        //starts recording
        audioRecorder.record()
    }
    
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(recording: false)
        audioRecorder.stop()
        //creates audio session
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
    
    func configureUI(recording: Bool) {
        if recording {
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            recordingLabel.text = "Recording in Progress"
        } else {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
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
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

