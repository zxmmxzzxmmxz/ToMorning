//
//  SingleEventViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-29.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
class SingleEventViewController: UIViewController,EKEventEditViewDelegate {

    var currevent:EKEvent?{
        didSet{
            eventid = currevent?.eventIdentifier
        }
    }
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    
    
    var eventmanager : EventManager?
    
    var eventid:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let event = currevent{
            eventid = event.eventIdentifier
        }
        updatelabels()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var backgroundimageview: UIImageView!
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let infomanager = InfoManager()
        self.backgroundimageview.image = UIImage(named: infomanager.currbackgroundimg)
    }
    func updatelabels(){
        if let event = currevent{
            eventTitleLabel.text = event.title
            let formatter = NSDateFormatter()
            formatter.dateFormat = "HH:mm"
            eventTimeLabel.text = formatter.stringFromDate(event.startDate) + "-" + formatter.stringFromDate(event.endDate)
            noteTextView.text = event.notes
        }
        else{
            eventTitleLabel.text = "Unknown"
            eventTimeLabel.text = "Unknown"
            noteTextView.text = "Unknown"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func editEvent(sender: AnyObject) {
        if let event = currevent{
            if let eventstore = eventmanager?.eventStore{
                let controller = EKEventEditViewController()
                controller.event = event
                controller.editViewDelegate = self
                controller.eventStore = eventstore
                self.presentViewController(controller, animated: true, completion: nil)
            }
        }
    }

    func eventEditViewController(controller: EKEventEditViewController,
        didCompleteWithAction action: EKEventEditViewAction){
            self.dismissViewControllerAnimated(true, completion: nil)
            if(eventmanager != nil){
                if(eventmanager!.iseventstoreavailable()){
                    currevent = eventmanager!.getEvent(eventid)
                }
            }
            else{
                currevent = nil
            }
            self.updatelabels()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
