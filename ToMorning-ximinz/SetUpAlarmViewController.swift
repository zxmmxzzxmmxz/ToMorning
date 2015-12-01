//
//  SetUpAlarmViewController.swift
//  ToMorning-ximinz
//
//  Created by Ximin Zhang on 2015-11-06.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit

class SetUpAlarmViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate{

    
    @IBOutlet weak var selectyourringtonelabel: UILabel!
    @IBOutlet weak var selectyouralarmtimelabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var backgroundimageview: UIImageView!
    @IBOutlet weak var musicTab: UIPickerView!
    
    //@IBOutlet weak var analogClockView : AnalogClock!
    
    let musicList = ["Summer","Whistle","Truth","Phantom","Dogs"]
    var musicTitle = "Summer"
    let infomanager = InfoManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer.enabled = false
        datePicker.datePickerMode = UIDatePickerMode.Time
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundimageview.image = UIImage(named: infomanager.currbackgroundimg)
        updatelabelsusinglanguange(infomanager.currlanguange)
    }

    func updatelabelsusinglanguange(languange:String){
        if(languange == "Chinese"){
            selectyouralarmtimelabel.text = "选择您的闹钟时间"
            selectyourringtonelabel.text = "选择您的铃声"
        }
        else{
            selectyouralarmtimelabel.text = "Select Your Alarm Time"
            selectyourringtonelabel.text = "Select Your Ringtone"
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func returnselectedDate()-> NSDate{
        return datePicker.date
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return musicList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return musicList[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        musicTitle = musicList[row]
    }
    
    func selectedMusicTitle()-> String{
        return musicTitle
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
