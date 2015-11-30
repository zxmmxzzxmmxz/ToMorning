//
//  EventManager.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-29.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import Foundation
import EventKit
class EventManager{
    private var eventstoreavailable = false
    private var calendar:EKCalendar?
    let eventStore = EKEventStore()
    func checkCalendarAuthorizationStatus() {
        eventStore.requestAccessToEntityType(EKEntityTypeReminder,
            completion: {(granted: Bool, error:NSError!) in
                if !granted {
                    print("Access to store not granted")
                    print("error is: \(error.description)")
                }
                else{
                    print("something")
                    self.eventstoreavailable = true
                }
        })
    }
    
    func iseventstoreavailable()->Bool{
        print(eventstoreavailable)
        return eventstoreavailable
    }
    func getCalendar(){
        let calendars = eventStore.calendarsForEntityType(EKEntityTypeReminder)
        for i in calendars as! [EKCalendar] {
            println("Calendar = \(i.title)")
        }
        if(calendars.count>0){
            calendar = (calendars[0] as! EKCalendar)
            print("Calendar is \(calendar!)")
        }
    }
    func getEvents(startDate:NSDate,endDate:NSDate){
        let reminder = EKReminder(eventStore: self.eventStore)
        
        reminder.title = "Go to the store and buy milk"
        reminder.calendar = eventStore.defaultCalendarForNewReminders()
        
        var error: NSError?
        
        eventStore.saveReminder(reminder, commit: true, error: &error)
        
        if let thiscalendar = calendar {
            let predicate = self.eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars:[thiscalendar])
            let events = eventStore.eventsMatchingPredicate(predicate) as? [EKEvent]
            print(events)
        }
        
    }
    
}