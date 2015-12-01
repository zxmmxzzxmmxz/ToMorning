//
//  CalendarViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-24.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit
import CoreLocation
import EventKitUI
class CalendarViewController: UIViewController,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,EKEventEditViewDelegate{

    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    let eventManage = EventManager()
    let infomanager = InfoManager()
    
    var currcity:String?{
        didSet{
            self.cityLabel.text = currcity
        }
    }
    
    var currhumidity:Double?
    
    var currweather:String?
    
    var currtemperature:Double?
    
    var currlocation:CLLocation?{
        didSet{
                self.loadweatherdata(self.currlocation!.coordinate)
        }
    }
    
    var events : [EKEvent]?{
        didSet{
            eventTableView.reloadData()
        }
    }
    
    @IBAction func newEvent(segue:UIStoryboardSegue){
        print("aa")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM.dd,yyyy EEEE"
        datelabel.text = formatter.stringFromDate(NSDate())
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        eventManage.checkCalendarAuthorizationStatus()
        print("getting events")
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getevents", userInfo: nil, repeats: false)
        //eventTableView.backgroundView=UIImageView(image: UIImage(named: "IMG_6774.PNG"))
        eventTableView.backgroundColor = UIColor.clearColor()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var backgroundimageview: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updatelabelsusinglanguange(infomanager.currlanguange)
        events = eventManage.getEvents()
        self.eventTableView.reloadData()
        backgroundimageview.image = UIImage(named: infomanager.currbackgroundimg)
        
    }
    
    @IBOutlet weak var todolistlabel: UILabel!
    @IBOutlet weak var temperaturetitlelabel: UILabel!
    @IBOutlet weak var weathertitlelabel: UILabel!
    @IBOutlet weak var humiditytitlelabel: UILabel!
    @IBOutlet weak var citytitlelabel: UILabel!
    func updatelabelsusinglanguange(languange:String){
        if(languange == "Chinese"){
            temperaturetitlelabel.text = "温度："
            weathertitlelabel.text = "天气："
            humiditytitlelabel.text = "湿度："
            citytitlelabel.text = "城市："
            todolistlabel.text = "待办事项"
        }
        else{
            temperaturetitlelabel.text = "City:"
            weathertitlelabel.text = "Humidity:"
            humiditytitlelabel.text = "Weather:"
            citytitlelabel.text = "Temperature:"
            todolistlabel.text = "To Do List"
        }
    }
    
    func getevents(){
        if(eventManage.iseventstoreavailable()){
            self.events = eventManage.getEvents()
        }
    }
    
    func eventEditViewController(controller: EKEventEditViewController,
        didCompleteWithAction action: EKEventEditViewAction){
            self.dismissViewControllerAnimated(true, completion: nil)
            NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getevents", userInfo: nil, repeats: false)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                println("Error: " + error.localizedDescription)
                println("")
                return
            }
            //print(self.locationManager.location.coordinate.longitude)
            //print(self.locationManager.location.coordinate.latitude)
            self.currlocation=self.locationManager.location
            if placemarks.count > 0
            {
                let pm = placemarks[0] as! CLPlacemark
                self.locationManager.stopUpdatingLocation()
                self.currcity = pm.locality
                self.temperatureLabel.text="Loading"
                self.humidityLabel.text="Loading"
                self.weatherLabel.text="Loading"
            }
            else
            {
                println("Error with the data.")
            }
        })
    }
    @IBAction func createEvent(sender: AnyObject) {
        let controller = EKEventEditViewController()
        controller.eventStore=eventManage.eventStore
        controller.editViewDelegate = self
        //controller.view.backgroundColor = UIColor(patternImage: UIImage(named:"IMG_6774.PNG")!)
        self.presentViewController(controller, animated: true, completion: nil)
    }

    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        println("Error: " + error.localizedDescription)
    }
    
    
    func loadweatherdata(location:CLLocationCoordinate2D){
        
        let urlstring = "http://api.openweathermap.org/data/2.5/weather?lat=" + String(stringInterpolationSegment: location.latitude)+"&lon="+String(stringInterpolationSegment:location.longitude)+"&appid=a5c7e6273ed6f922eb8a52d14d3c0056"
        let url = NSURL(string: urlstring)
        let session = NSURLSession.sharedSession()
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            //println(NSString(data: data, encoding: NSUTF8StringEncoding))
            if error != nil{
                return
            }
            else{
                var responseDict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data,options: NSJSONReadingOptions.MutableContainers, error:nil) as! NSDictionary
                if let main = responseDict["main"] as? NSDictionary{
                    if let humidity = main["humidity"] as? Double{
                        self.currhumidity = humidity
                        //print("set humidity")
                    }
                    if let temp = main["temp"] as? Double{
                        self.currtemperature = temp - 273.15
                        //print("set temp")
                    }
                }
                if let weather = responseDict["weather"] as? NSArray{
                    if let condition = weather[0]["main"] as? String{
                        self.currweather = condition
                        //print("set weather")
                    }
                }
                //println("jsonObject :\(responseDict)")
                //print(responseDict)
                print("updating\n")
                dispatch_async(dispatch_get_main_queue()){
                    self.updateLabels()
                }
            }
        }
        
        dataTask.resume()
    }
    
    
    func updateLabels(){
        cityLabel.text=currcity ?? "Unknown"
        if currhumidity != nil{
            humidityLabel.text=String(format: "%3.0f %",currhumidity!)
        }
        else{
            humidityLabel.text = "Unkown"
        }
        weatherLabel.text=currweather ?? "Unknown"
        if currtemperature != nil{
            temperatureLabel.text=String(format:"%.1f°C",currtemperature!)
        }
        else{
            temperatureLabel.text = "Unknown"
        }
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath)
        let cell = dequeued as! UITableViewCell
        if self.events != nil {
            cell.textLabel?.text = self.events![indexPath.row].title
        }
        else {
            cell.textLabel?.text=""
        }
        cell.backgroundColor=UIColor.lightGrayColor()
        return cell
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destination = segue.destinationViewController as? SingleEventViewController{
            if events != nil{
                destination.currevent = events![eventTableView.indexPathForSelectedRow()!.row]
            }
            destination.eventmanager = self.eventManage
        }
    }
    

}
