//
//  EventManager.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-29.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import Foundation
import EventKit
import EventKitUI
class EventManager{
    private var eventstoreavailable = false
    private var calendar:EKCalendar?
    let eventStore = EKEventStore()
    func checkCalendarAuthorizationStatus() {
        eventStore.requestAccessToEntityType(EKEntityTypeEvent, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                self.eventstoreavailable=true
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    //self.needPermissionView.fadeIn()
                })
            }
        })    }
    
    func iseventstoreavailable()->Bool{
        print(eventstoreavailable)
        return eventstoreavailable
    }

    func getEvents()->[EKEvent]?{
        var startDate=NSDate()
        var endDate=NSDate().dateByAddingTimeInterval(3600*24)
        var predicate2 = eventStore.predicateForEventsWithStartDate(startDate,
            endDate: endDate, calendars: nil)
        
        var eV = eventStore.eventsMatchingPredicate(predicate2) as? [EKEvent]
        
        if eV != nil {
            return eV
        }

        else{
            return []
        }
        
    }
    
    func getEvent(eventid:String?)->EKEvent?{
        if let existid = eventid{
            return eventStore.eventWithIdentifier(eventid)
        }
        return nil
    }

    
}