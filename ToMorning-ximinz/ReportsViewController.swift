//
//  ReportsViewController.swift
//  ToMorning-ximinz
//
//  Created by Ximin Zhang on 2015-11-19.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit

@IBDesignable class ReportsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet weak var backgroundimageview: UIImageView!
    @IBOutlet weak var tv: UITableView!
    var heartratearray = ["sample"]
    let fileManager = FileManager()
    let infomanager = InfoManager()
    //var healthManager:HealthManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.backgroundColor = UIColor.clearColor()
        //selected=heartratearray.count
        let filelist = fileManager.gettitlelist()
        //print("filelist is \(filelist)")
        if(filelist.count>0){
            heartratearray=filelist
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.backgroundimageview.image = UIImage(named: infomanager.currbackgroundimg)
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as?SingleReportViewController{
            destination.filename=heartratearray[tv.indexPathForSelectedRow()?.row ?? 0]
        }
        tv.resignFirstResponder()
        
    }
    

}
