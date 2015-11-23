//
//  SingleReportViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-19.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit

class SingleReportViewController: UIViewController,GraphViewDelegate{
    @IBOutlet weak var gotobedtimelabel: UILabel!
    @IBOutlet weak var sleepingtimeintotallabel: UILabel!
    @IBOutlet weak var lightsleepintotallabel: UILabel!
    @IBOutlet weak var deepsleepintotallabel: UILabel!
    
    
    @IBOutlet weak var graphview: GraphView!
    var filename:String?
    let fileManager = FileManager()
    var heartratearray=[16,59,1,70,70]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphview.dataSource=self
        if let existfilename = filename{
            print("filename is \(existfilename)\n")
            if(existfilename != "sample"){
                let temparr = fileManager.getdata(existfilename)
                heartratearray=[]
                print("temparr is \(temparr)\n")
                var i = 0
                for data in temparr{
                    if(i>3){
                        heartratearray.append(Int(data))
                    }
                    i++
                }
                let gotobedhour = temparr[0]
                let gotobedmin = temparr[1]
                let wakeuphour = temparr[2]
                let wakeupmin = temparr[3]
                gotobedtimelabel.text=String(stringInterpolationSegment: gotobedhour) + String(stringInterpolationSegment: gotobedmin)
                var totaltime = Int(wakeuphour) - Int(gotobedhour)
                if(totaltime<0){
                    totaltime=totaltime+24
                }
                sleepingtimeintotallabel.text = String(stringInterpolationSegment: totaltime) + "hours"
                
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldGetIntArray(sender: GraphView) -> [Int] {
        return heartratearray
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
