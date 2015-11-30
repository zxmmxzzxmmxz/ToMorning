//
//  CalendarViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-24.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit
import CoreLocation

class CalendarViewController: UIViewController,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var eventTableView: UITableView!
    
    
    let locationManager = CLLocationManager()
    let eventManage = EventManager()
    
    var currcity:String?{
        didSet{
            cityLabel.text=currcity!
        }
    }
    
    var currhumidity:Double?{
        didSet{
            humidityLabel.text=String(format: "%3.0f",currhumidity!)
        }
    }
    
    var currweather:String?{
        didSet{
            weatherLabel.text=currweather!
        }
    }
    
    var currtemperature:Double?{
        didSet{
            temperatureLabel.text=String(format:"%.1f°C",currtemperature!)
        }
    }
    
    var currlocation:CLLocation?{
        didSet{
            dispatch_async(dispatch_get_main_queue()){
                self.loadweatherdata(self.currlocation!.coordinate)
            }
        }
    }
    
    @IBAction func newEvent(segue:UIStoryboardSegue){
        print("aa")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        eventManage.checkCalendarAuthorizationStatus()
        print("getting calendar")
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "getcalendar", userInfo: nil, repeats: false)
        eventTableView.backgroundView=UIImageView(image: UIImage(named: "IMG_6774.PNG"))
        // Do any additional setup after loading the view.
    }
    func getcalendar(){
        if(eventManage.iseventstoreavailable()){
            eventManage.getCalendar()
            eventManage.getEvents(NSDate().dateByAddingTimeInterval(-360000), endDate: NSDate().dateByAddingTimeInterval(360000))
        }
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
            }
        }
        
        dataTask.resume()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIImageView(image: UIImage(named: "IMG_6774.PNG"))
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath)
        let cell = dequeued as! UITableViewCell
        cell.textLabel?.text="123"
        cell.backgroundColor=UIColor.lightGrayColor()
        return cell
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
