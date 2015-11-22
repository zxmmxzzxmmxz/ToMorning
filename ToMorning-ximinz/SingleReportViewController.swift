//
//  SingleReportViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-19.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit

class SingleReportViewController: UIViewController,GraphViewDelegate{
    
    @IBOutlet weak var graphview: GraphView!
    
    var heartratearray=[30,30,30,30,40]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        graphview.dataSource=self
        
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
