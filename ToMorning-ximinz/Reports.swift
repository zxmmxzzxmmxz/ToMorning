//
//  Reports.swift
//  ToMorning-ximinz
//
//  Created by Ximin Zhang on 2015-11-16.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import Foundation
import HealthKit

class Reports{
    var startdate:NSDate?
    var enddate:NSDate?
    var datapoints :[Double] = []
    var lightsleepintotal:Int=0
    var deepsleepintotal:Int=0
    init(start:NSDate){
        startdate=start
    }
    
    func getdatapoints()->[Double]{
        return datapoints
    }
    
    func enterdatapoint(data:Double){
        datapoints.append(data)
    }
    
    func setenddate(end:NSDate){
        enddate=end
    }
    
    func wakeuptimeinhourminformat()->String{
        let formatter=NSDateFormatter()
        formatter.dateFormat="HH:mm"
        let result=formatter.stringFromDate(enddate!)
        return result
    }
    
    func addlightsleeptime_ten_mins(){
        lightsleepintotal+=10
    }
    
    func adddeepsleeptime_ten_mins(){
        deepsleepintotal+=10
    }
    
    func getlightsleeptime()->Int{
        return 200
        //return lightsleepintotal
    }
    
    func getdeepsleeptime()->Int{
        return 100
        //return deepsleepintotal
    }
    
    func getwholeinarray()->NSArray{
        return NSArray(array: [startdate!,enddate!,lightsleepintotal,deepsleepintotal,[54,54,51,57,51,49,46,54,54,51,49,49,51,74,54,88,77,138,61,77,88,54,81,54,52,81,50,97,77,49,49,51,46]])
        //return NSArray(array: [startdate!,enddate!,lightsleepintotal,deepsleepintotal,datapoints])
    }
    
    func loadfromarray(array:NSArray){
        startdate=(array[0] as! NSDate)
        enddate=(array[1] as! NSDate)
        lightsleepintotal=(array[2] as! Int)
        deepsleepintotal=(array[3] as! Int)
        datapoints=(array[4] as! [Double])
    }
    
}