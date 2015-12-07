//
//  SettingsViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-30.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var aboutuslabel: UILabel!
    @IBOutlet weak var languangelabel: UILabel!
    @IBOutlet weak var themetitlelabel: UILabel!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var ThemeButton3: UIButton!
    @IBOutlet weak var ThemeButton2: UIButton!
    @IBOutlet weak var ThemeButton1: UIButton!
    var currbackgroundimg = "IMG_6774.PNG"
    let infomanager = InfoManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        currbackgroundimg = infomanager.currbackgroundimg
        backgroundView.image = UIImage(named: currbackgroundimg)
        updatelabelsusinglanguange(infomanager.currlanguange)
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
    @IBAction func setlanguangetochinese(sender: AnyObject) {
        infomanager.setlanguange("Chinese")
        updatelabelsusinglanguange(infomanager.currlanguange)
    }
    @IBAction func setlanguangetoenglish(sender: AnyObject) {
        infomanager.setlanguange("English")
        self.updatelabelsusinglanguange(infomanager.currlanguange)
    }
    
    
    func updatelabelsusinglanguange(languange:String){
        if(languange == "Chinese"){
            aboutuslabel.text="关于我们"
            languangelabel.text="语言"
            themetitlelabel.text="主题"
            ThemeButton1.setTitle("主题1", forState: .Normal)
            ThemeButton2.setTitle("主题2", forState: .Normal)
            ThemeButton3.setTitle("主题3", forState: .Normal)
        }
        else{
            aboutuslabel.text="About Us"
            languangelabel.text="Languanges"
            themetitlelabel.text="Themes"
            ThemeButton1.setTitle("Theme 01", forState: .Normal)
            ThemeButton2.setTitle("Theme 02", forState: .Normal)
            ThemeButton3.setTitle("Theme 03", forState: .Normal)
        }
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
