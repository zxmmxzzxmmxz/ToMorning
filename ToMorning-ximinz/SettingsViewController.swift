//
//  SettingsViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-30.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var ThemeButton3: UIButton!
    @IBOutlet weak var ThemeButton2: UIButton!
    @IBOutlet weak var ThemeButton1: UIButton!
    var currbackgroundimg = "IMG_6781.PNG"
    let infomanager = InfoManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        currbackgroundimg = infomanager.currbackgroundimg
        backgroundView.image = UIImage(named: currbackgroundimg)
        // Do any additional setup after loading the view.
    }

    @IBAction func setimgto1(sender: AnyObject) {
        self.currbackgroundimg = "IMG_6774.PNG"
        infomanager.setbackgroundimg("IMG_6774.PNG")
        self.backgroundView.image = UIImage(named: infomanager.currbackgroundimg)
        self.backgroundView.setNeedsDisplay()
    }
    
    @IBAction func setimgto2(sender: AnyObject) {
        self.currbackgroundimg = "IMG_6781.PNG"
        infomanager.setbackgroundimg("IMG_6781.PNG")
        self.backgroundView.image = UIImage(named: infomanager.currbackgroundimg)
        self.backgroundView.setNeedsDisplay()
    }
    @IBAction func setimgto3(sender: AnyObject) {
        self.currbackgroundimg = "IMG_6860.PNG"
        infomanager.setbackgroundimg("IMG_6860.PNG")
        self.backgroundView.image = UIImage(named: infomanager.currbackgroundimg)
        self.backgroundView.setNeedsDisplay()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
