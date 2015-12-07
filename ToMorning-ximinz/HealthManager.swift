//
//  File.swift
//  ToMorning-ximinz
//
//  Created by Ximin Zhang on 2015-11-14.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    var enabled=false
    var rateresult:Double?
    //test use
    var initheartrate:Double?
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        }
        else {
            return nil
        }
    }()
    
    let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())

    func ifhealthkitavailable()->Bool{
        return enabled
    }
    
//    func getsleepdatafromdate(startdate:NSDate)->[Double]{
//        print("startdate is \(startdate)")
//        var dataset:[Double]=[]
//        let HeartRate = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
//        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(startdate, endDate:NSDate(), options: .None)
//        let stepsSampleQuery = HKSampleQuery(sampleType: HeartRate,
//            predicate: mostRecentPredicate,
//            limit: 120,
//            sortDescriptors: nil)
//            { [unowned self] (query, results, error) in
//                if let results = results as? [HKQuantitySample] {
//                    //print(_stdlib_getDemangledTypeName(results))
//                    //print(_stdlib_getDemangledTypeName(results[0]))
//                    //print("heartrate is \(results[0].quantity.doubleValueForUnit(self.heartRateUnit))\n")
//                    print("heartrate detected\n")
//                    for result in results{
//                        print("this result is \(result.quantity.doubleValueForUnit(self.heartRateUnit))")
//                        dataset.append(result.quantity.doubleValueForUnit(self.heartRateUnit))
//                    }
//                }
//            }
//        // Don't forget to execute the Query!
//        healthStore?.executeQuery(stepsSampleQuery)
//        return dataset
//    }
    func getinitheartrate()->Double?{
        return initheartrate
    }
    
    func authorizeHealthKit()
    {

        let heartbeatrateid = HKCharacteristicType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        
        let dataTypesToRead = NSSet(objects:
            heartbeatrateid)
        healthStore?.requestAuthorizationToShareTypes(dataTypesToRead as Set<NSObject>,
            readTypes: dataTypesToRead as Set<NSObject>,
            completion: { (success, error) -> Void in
                if success {
                    println("success")
                    self.enabled=true
                } else {
                    println(error.description)
                }
        })
    
    }
    
    func setInitHeartRate(){
        print("setting initial hearrate\n")
        let HeartRate = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let past = NSDate(timeInterval: -1800, sinceDate: NSDate())
        let now = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        let sortDescriptor = NSSortDescriptor(key:HKSampleSortIdentifierStartDate, ascending: true)
        let stepsSampleQuery = HKSampleQuery(sampleType: HeartRate,
            predicate: mostRecentPredicate,
            limit: 30,
            sortDescriptors: [sortDescriptor])
            { [unowned self] (query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    //print(_stdlib_getDemangledTypeName(results))
                    //print(_stdlib_getDemangledTypeName(results[0]))
                    //print("initheartrate is \(results[results.count-1].quantity.doubleValueForUnit(self.heartRateUnit))\n")
                    if(results.count>0){
                        self.initheartrate=results[0].quantity.doubleValueForUnit(self.heartRateUnit)
                    }
                }
        }
        // Don't forget to execute the Query!
        healthStore?.executeQuery(stepsSampleQuery)

    }
    
    func getLatestHeartRateInHalfHour()->Double?{
        let HeartRate = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let past = NSDate(timeInterval: -1800, sinceDate: NSDate())
        let now = NSDate()
        let mostRecentPredicate = HKQuery.predicateForSamplesWithStartDate(past, endDate:now, options: .None)
        let stepsSampleQuery = HKSampleQuery(sampleType: HeartRate,
            predicate: mostRecentPredicate,
            limit: 1800,
            sortDescriptors: nil)
            { [unowned self] (query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    //print(_stdlib_getDemangledTypeName(results))
                    //print(_stdlib_getDemangledTypeName(results[0]))
                    if results.count>=1 {
                        //print("currheartrate is \(results[results.count-1].quantity.doubleValueForUnit(self.heartRateUnit))\n")
                        self.rateresult=results[results.count-1].quantity.doubleValueForUnit(self.heartRateUnit)
                    }
                }
        }
        // Don't forget to execute the Query!
        healthStore?.executeQuery(stepsSampleQuery)
        let temp = self.rateresult
        cleardata()
        return temp
    }
    
    
    func saveHeartRateIntoHealthStore(height:Double) -> Void
    {
        // Save the user's heart rate into HealthKit. Testing use
        let heartRateQuantity: HKQuantity = HKQuantity(unit: heartRateUnit, doubleValue: height)
        
        var heartRate : HKQuantityType = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let nowDate: NSDate = NSDate()
        
        let heartRateSample: HKQuantitySample = HKQuantitySample(type: heartRate
            , quantity: heartRateQuantity, startDate: nowDate, endDate: nowDate)
        
        let completion: ((Bool, NSError!) -> Void) = {
            (success, error) -> Void in
            
            if !success {
                println("An error occured saving the Heart Rate sample \(heartRateSample). In your app, try to handle this gracefully. The error was: \(error).")
                
                abort()
            }
            
        }
        
        self.healthStore!.saveObject(heartRateSample, withCompletion: completion)
        
    }
    
    func cleardata(){
        rateresult = nil
    }
}