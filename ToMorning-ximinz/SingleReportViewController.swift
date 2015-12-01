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
    
    @IBOutlet weak var detaillabel: UILabel!
    @IBOutlet weak var wakeuptimelabel: UILabel!
    @IBOutlet weak var estimatetimeinbedlabel: UILabel!
    @IBOutlet weak var totallightsleeplabel: UILabel!
    @IBOutlet weak var totaldeepsleeplabel: UILabel!
    
    @IBOutlet weak var graphview: GraphView!
    
    var filename:String?
    let fileManager = FileManager()
    var heartratearray=[50,60,70]//sample use
    var hours = "hours"
    var minutes = "min"
    override func viewDidLoad() {
        super.viewDidLoad()
        graphview.dataSource=self
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var backgroundimageview: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let infomanager = InfoManager()
        self.backgroundimageview.image = UIImage(named: infomanager.currbackgroundimg)
        updatelabelusinglanguange(infomanager.currlanguange)
        loadreport()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldGetIntArray(sender: GraphView) -> [Int] {
        return heartratearray
    }
    func updatelabelusinglanguange(languange:String){
        if(languange == "Chinese"){
            detaillabel.text = "详细"
            wakeuptimelabel.text = "醒来时间"
            estimatetimeinbedlabel.text = "睡眠总时间"
            totallightsleeplabel.text = "轻度睡眠时间"
            totaldeepsleeplabel.text = "深度睡眠时间"
        }
        else{
            detaillabel.text = "Detail"
            wakeuptimelabel.text = "Wake Up Time:"
            estimatetimeinbedlabel.text = "Estimate Time in Bed:"
            totallightsleeplabel.text = "Total Light Sleep:"
            totaldeepsleeplabel.text = "Total Deep Sleep:"
        }
        loadreport()
    }
    func loadreport(){
        if let existfilename = filename{
            //print("filename is \(existfilename)\n")
            if(existfilename != "sample"){
                let temparr = fileManager.getdata(existfilename)
                //print("temparr is \(temparr)\n")
                let report = Reports(start: NSDate())
                report.loadfromarray(temparr)
                gotobedtimelabel.text=report.wakeuptimeinhourminformat()
                var totaltime = (report.getdeepsleeptime()+report.getlightsleeptime())/60
                if(totaltime<0){
                    totaltime=totaltime+24
                }
                sleepingtimeintotallabel.text = String(stringInterpolationSegment: totaltime) + " " + hours
                lightsleepintotallabel.text = String(stringInterpolationSegment: report.getlightsleeptime())+" " + minutes
                deepsleepintotallabel.text = String(stringInterpolationSegment: report.getdeepsleeptime())+" "+minutes
                var datapointsindouble = report.getdatapoints()
                var datapointsinint:[Int]=[]
                for point in datapointsindouble{
                    datapointsinint.append(Int(point))
                }
                if(datapointsinint.count>0){
                    heartratearray=datapointsinint
                    print("hearbeatrate array is : \(heartratearray)")
                }
            }
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
