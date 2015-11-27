//
//  ReportsViewController.swift
//  ToMorning-ximinz
//
//  Created by Ximin Zhang on 2015-11-19.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit

@IBDesignable class ReportsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var tv: UITableView!
    var heartratearray = ["sample"]
    var selected:Int=0
    let fileManager = FileManager()
    //var healthManager:HealthManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.backgroundView = UIImageView(image: UIImage(named: "IMG_6774.PNG"))
        //selected=heartratearray.count
        let filelist = fileManager.gettitlelist()
        print("filelist is \(filelist)")
        if(filelist.count>0){
            heartratearray=filelist
            selected=heartratearray.count-1
        }
        // Do any additional setup after loading the view.
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIImageView(image: UIImage(named: "IMG_6774.PNG"))
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
        cell.backgroundColor=UIColor.lightGrayColor()
        return cell
    }
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selected=indexPath.row
        //tv.resignFirstResponder()
        print("\n\n\nselected is \(selected)\n\n\n")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as?SingleReportViewController{
            print("\n\n\nselected is \(heartratearray.count-1-selected)\n\n\n")
            destination.filename=heartratearray[heartratearray.count-1-selected]
        }
        tv.resignFirstResponder()
        
    }
    

}
