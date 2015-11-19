//
//  File.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-14.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import Foundation
import HealthKit

class HealthManager {
    var enabled=false
    let healthStore: HKHealthStore? = {
        if HKHealthStore.isHealthDataAvailable() {
            return HKHealthStore()
        } else {
            return nil
        }
        }()
    
    let heartRateUnit: HKUnit = HKUnit.countUnit().unitDividedByUnit(HKUnit.minuteUnit())

    
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
    func getHeartRate(){
        let HeartRate = HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierHeartRate)
        let stepsSampleQuery = HKSampleQuery(sampleType: HeartRate,
            predicate: nil,
            limit: 100,
            sortDescriptors: nil)
            { [unowned self] (query, results, error) in
                if let results = results as? [HKQuantitySample] {
                    print(_stdlib_getDemangledTypeName(results))
                    print(_stdlib_getDemangledTypeName(results[0]))
                    print(results[0].quantity.doubleValueForUnit(self.heartRateUnit))
                }
        }
        
        // Don't forget to execute the Query!
        healthStore?.executeQuery(stepsSampleQuery)

    }
    func saveHeartRateIntoHealthStore(height:Double) -> Void
    {
        // Save the user's heart rate into HealthKit.
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
}