//
//  CalendarViewController.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-24.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import UIKit
import CoreLocation

class CalendarViewController: UIViewController,CLLocationManagerDelegate {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var rainFallProbabilityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate=self
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil)
            {
                println("Error: " + error.localizedDescription)
                println("")
                return
            }
            print(self.locationManager.location.coordinate.longitude)
            print(self.locationManager.location.coordinate.latitude)
            self.loadweatherdata(self.locationManager.location.coordinate)
            if placemarks.count > 0
            {
                let pm = placemarks[0] as! CLPlacemark
                self.displayLocationInfo(pm)
            }
            else
            {
                println("Error with the data.")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark)
    {
        
        self.locationManager.stopUpdatingLocation()
        cityLabel.text = placemark.locality
        println(placemark.postalCode)
        println(placemark.administrativeArea)
        println(placemark.country)
        
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
                
                //println("jsonObject :\(responseDict)")
                print(responseDict)
            }
        }
        
        dataTask.resume()
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
