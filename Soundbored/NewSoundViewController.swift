//
//  NewSoundViewController.swift
//  Soundbored
//
//  Created by Dion Pettaway on 7/27/15.
//  Copyright (c) 2015 Kalani Pettaway. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class NewSoundViewController : UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        var baseString : String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String
        self.audioURL = NSUUID().UUIDString + ".m4a"
        var pathComponents = [baseString, self.audioURL]
        var audioNSURL = NSURL.fileURLWithPathComponents(pathComponents)!
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        var recordSettings: [NSObject : AnyObject] = Dictionary()
        recordSettings[AVFormatIDKey] = kAudioFormatMPEG4AAC
        recordSettings[AVSampleRateKey] = 44100.0
        recordSettings[AVNumberOfChannelsKey] = 2
        
        self.audioRecorder = AVAudioRecorder(URL: audioNSURL, settings: recordSettings, error: nil)
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var soundTextField: UITextField!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder
    var audioURL: String
    var soundListViewController = SoundListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Awoo
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        var context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

        
        //create sound object
        var sound = NSEntityDescription.insertNewObjectForEntityForName("Sound", inManagedObjectContext: context) as! Sound
        sound.name = soundTextField.text
        sound.url = self.audioURL
        // Sound gets saved to CoreData
        context.save(nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func recordTapped(sender: AnyObject) {
        if self.audioRecorder.recording {
            self.audioRecorder.stop()
            self.recordButton.setTitle("RECORD", forState: UIControlState.Normal)
        } else {
            var session = AVAudioSession.sharedInstance()
            session.setActive(true, error: nil)
            self.audioRecorder.record()
            self.recordButton.setTitle("FINISH RECORDING", forState: UIControlState.Normal)
        }
        
    }
    
}
