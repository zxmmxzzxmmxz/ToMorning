//
//  ReportsViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-19.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit

class ReportsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tv: UITableView!
    var heartratearray = ["2015-09-08","2015-09-10"]
    var selected:Int?
    let fileManager = FileManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        selected=heartratearray.count
        let filelist = fileManager.gettitlelist()
        print("filelist is \(filelist)")
        heartratearray=filelist
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  heartratearray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = heartratearray[indexPath.row]
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        let cell = dequeued as! UITableViewCell
        cell.textLabel?.text=data
        return cell
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selected=indexPath.row
        print("\n\n\nselected\n\n\n")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    

}
