//
//  ViewController.swift
//  ToMorning-ximinz
//
//  Created by Ximin Zhang on 2015-11-06.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit
import AVFoundation
import HealthKit
class AlarmViewController: UIViewController {
    
    var alarmDate=NSDate(timeInterval: -90, sinceDate: NSDate())
    let formatter=NSDateFormatter()
    var musicTitle = "Summer"
    var musicPlayer = AVPlayer()
    var audioPlayer = AVAudioPlayer()
    let message="Put iWatch on and enjoy the sleep!"
    var healthManager:HealthManager = HealthManager()
    var enabled=false
    var timerforalarm:NSTimer?
    var timerforclock:NSTimer?
    var timerforheartrate:NSTimer?
    var preheartrate=Double()
    var currheartrate=Double()
    
    @IBOutlet weak var analogClockView: AnalogClock!
    @IBOutlet weak var alarmLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    /////////////////////////////////////////////////////////////////////////////////////////////
    // setAlarm(segue:UIStoryboardSegue)
    // Input: segue object which included the data coming from alarm setup UI
    // Return: Null
    // Discription: This functions takes the user setting date and translate it into "HH:MM AM/
    //              PM" format. Also set the user's slected music as our system alarm music source
    /////////////////////////////////////////////////////////////////////////////////////////////
    @IBAction func setAlarm(segue:UIStoryboardSegue){
        let source = segue.sourceViewController as! SetUpAlarmViewController
        alarmDate = source.returnselectedDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH"
        if(formatter.stringFromDate(alarmDate).toInt()!<12){
            formatter.dateFormat="HH:mm"
            alarmLabel.text=formatter.stringFromDate(alarmDate)+"AM"
        }
        else{
            formatter.dateFormat="HH"
            var hour=formatter.stringFromDate(alarmDate).toInt()!-12
            if(hour==0){
                hour=12
            }
            formatter.dateFormat="mm"
            alarmLabel.text=String(hour)+":"+formatter.stringFromDate(alarmDate)+"PM"
        }
        musicTitle=source.selectedMusicTitle()
        var path = NSBundle.mainBundle().URLForResource(musicTitle, withExtension: "mp3")
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: path!, error: &error)
        if(error==nil){
            audioPlayer.prepareToPlay()
        }
        messageLabel.text=message
        self.enabled=healthManager.enabled
        print(enabled)
        if(enabled){
            //healthManager.saveHeartRateIntoHealthStore()
            if let temprate = healthManager.getHeartRate(){
                self.currheartrate=temprate
                self.preheartrate=temprate
                print("GET PRE RATE: \(currheartrate)")
                timerforheartrate = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "setpreviousheartrate", userInfo: nil, repeats: true)
            }
        }
        formatter.dateFormat="ss"
        let tempsec = formatter.stringFromDate(alarmDate).toInt()!
        alarmDate=alarmDate.dateByAddingTimeInterval(Double(-tempsec))
    
    }
    
    var times = 1.0
    func setpreviousheartrate(){
        if(times>3.0){
            timerforheartrate!.invalidate()
            timerforheartrate=nil
        }
        currheartrate=healthManager.getHeartRate()!
        print("current rate is \(currheartrate)\n prevrate is \(preheartrate)")
        preheartrate=(preheartrate*times + currheartrate)
        times++
        preheartrate=preheartrate/times
        print("AFTER:prevrate is \(preheartrate)")
    }
    /////////////////////////////////////////////////////////////////////////////////////////////
    // viewDidLoad()
    // Input: Null
    // Return: Null
    // Discription: This function checks the triggerAlarm() every 1 seconds and update 
    //              renewAnalogClock() UI in a 60 seconds bases. Also pre-loading the alarm music
    //              source.
    /////////////////////////////////////////////////////////////////////////////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        healthManager.authorizeHealthKit()
        alarmLabel.text = "--:--"
        var path = NSBundle.mainBundle().URLForResource(musicTitle, withExtension: "mp3")
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: path!, error: &error)
        audioPlayer.prepareToPlay()
        messageLabel.text=""
        print("here3")
    }
    
    override func viewWillAppear(animated: Bool) {
        print("here2")
        analogClockView.setNeedsDisplay()
        timerforalarm = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "triggerAlarm", userInfo: nil, repeats: true)
        timerforclock = NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "renewAnalogClock", userInfo: nil, repeats: true)
    }
    override func viewWillDisappear(animated: Bool) {
        print("here")
        if(analogClockView.layer.sublayers.count  != 0){
            for view in analogClockView.layer.sublayers{
                view.removeFromSuperlayer()
            }
        }
        timerforalarm!.invalidate()
        timerforalarm=nil
        timerforclock!.invalidate()
        timerforclock=nil
        timerforheartrate?.invalidate()
        timerforheartrate=nil
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    // triggerAlarm()
    // Input: Null
    // Return: Null
    // Discription: This function compares the date and time between user setting and current
    //              time. If they matched, it will trigger the preloaded alarm music.
    ///////////////////////////////////////////////////////////////////////////////////////////
    func triggerAlarm(){
        if(enabled){
            let earliestdate=alarmDate.dateByAddingTimeInterval(-1800)
            if(NSDate().earlierDate(earliestdate) == earliestdate && NSDate().laterDate(alarmDate) == alarmDate){
                print("here")
                if(shouldWakeUp()){
                    triggerAlert()
                }
            }
        }
        else{
            formatter.dateFormat="HH:mm"
            if(formatter.stringFromDate(NSDate())==formatter.stringFromDate(alarmDate)){
                triggerAlert()
            }
        }
    }
    
    ////////////////////////////////////////////////////////
    // renewAnalogClock()
    // Input: Null
    // Return: Null
    // Discription: Refresh the entire analogClock UI
    ////////////////////////////////////////////////////////
    func renewAnalogClock(){
        for view in analogClockView.layer.sublayers{
            view.removeFromSuperlayer()
        }
        self.analogClockView.setNeedsDisplay()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        alarmDate = NSDate(timeInterval: -90, sinceDate: NSDate())
        messageLabel.text=""
        alarmLabel.text="--:--"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func shouldWakeUp()->Bool{
//        heartrate=healthManager.getHeartRate()
//        if
        return true
    }
    
    func triggerAlert(){
        let alertController = UIAlertController(title: "Light Sleep Detected", message: "Time To Wake Up", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            self.alarmLabel.text="--:--"
            self.audioPlayer.stop()
            self.messageLabel.text=""
        }
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
        audioPlayer.play()
        alarmDate = NSDate(timeInterval: -90, sinceDate: NSDate())
    }
}

