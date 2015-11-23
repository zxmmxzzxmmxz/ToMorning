//
//  SingleReportViewController.swift
//  ToMorning-ximinz
//
//  Created by Ximin Zhang on 2015-11-19.
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
    var heartratearray=[50,60,70]//sample use
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphview.dataSource=self
        if let existfilename = filename{
            print("filename is \(existfilename)\n")
            if(existfilename != "sample"){
                let temparr = fileManager.getdata(existfilename)
                print("temparr is \(temparr)\n")
                let report = Reports(start: NSDate())
                report.loadfromarray(temparr)
                gotobedtimelabel.text=report.wakeuptimeinhourminformat()
                var totaltime = (report.getdeepsleeptime()+report.getlightsleeptime())/60
                if(totaltime<0){
                    totaltime=totaltime+24
                }
                sleepingtimeintotallabel.text = String(stringInterpolationSegment: totaltime) + " hours"
                lightsleepintotallabel.text = String(stringInterpolationSegment: report.getlightsleeptime())+" minutes"
                deepsleepintotallabel.text = String(stringInterpolationSegment: report.getdeepsleeptime())+" minutes"
                var datapointsindouble = report.getdatapoints()
                var datapointsinint:[Int]=[]
                for point in datapointsindouble{
                    datapointsinint.append(Int(point))
                }
                if(datapointsinint.count>0){
                    heartratearray=datapointsinint
                }
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
