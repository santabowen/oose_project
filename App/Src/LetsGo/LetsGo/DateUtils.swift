//
//  DateUtils.swift
//  LetsGo
//
//  Created by lv huizhan on 10/23/15.
//  Copyright © 2015 Xi Yang. All rights reserved.
//

import Foundation


/**
    Includes two NSDate -> String conversions.
*/
extension NSDate {
    /**
     Converts a NSDate object to readable date string of a moment.
     - parameter self a NSDate object.
     - return a string.
    */
    func toDateMediumString() -> NSString? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MMM/dd/yy E, h:mm a"
        return formatter.stringFromDate(self)
    }
    
    func toDatetimeString() -> NSString? {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.stringFromDate(self)
    }
    
    /**
     Converts a NSDate object to readable date string of a time period.
     - parameter self a NSDate object.
     - return a string.
    */
    func toDurationMediumString() -> NSString? {
        // Get the string from NSDate object.
        let formatter = NSDateFormatter()
        formatter.dateFormat = "H:mm"
        // Split the string into string array.
        let timeStr = formatter.stringFromDate(self)
        let timeArr = timeStr.componentsSeparatedByString(":")
        let h : String = timeArr[0]
        let m : String = timeArr[1]
        return NSDate.durationStrFromHM(h, m: m)
    }
    /**
     Gets a NSDate object from data string of hour and minute.
     - parameter h: hour value.
     - parameter m: minute value.
     - return a NSDate.
     */
    class func durationStrFromHM(h:String, m:String) -> NSString? {
        var s:String = ""
        if h == "1"{
            s = s + h + " hour "
        }
        else if h != "0"{
            s = s + h + " hours "
        }
        if (m != "0") && (m != "00"){
            s = s + m + " minutes"
        }
        
        if s == ""{
            s = "0 minutes"
        }
        return s
    }
    
    /**
     Gets a NSDate object from an integer.
     - parameter duration: an integer.
     - return a NSDate.
     */
    public class func durationStrFromInt(duration: Int) -> NSString? {
        let h = String(duration/3600)
        let m = String((duration%3600)/60)
        return durationStrFromHM(h, m: m)
    }
    /**
     Rounds minutes to a minimum interval of ten minutes.
     - parameter self a NSDate.
     - return a NSDate.
     */
    func roundToTenMinutes() -> NSDate {
        let componentMask : NSCalendarUnit = ([NSCalendarUnit.Year , NSCalendarUnit.Month , NSCalendarUnit.Day , NSCalendarUnit.Hour ,NSCalendarUnit.Minute])
        let components = NSCalendar.currentCalendar().components(componentMask, fromDate: self)
        
        components.minute += 10 - components.minute % 10
        components.second = 0
        if (components.minute == 0) {
            components.hour += 1
        }
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    /**
     Converts a date to an integer(in seconds).
     - parameter self a NSDate.
     - return an integer.
     */
    func toDurationSeconds() -> Int? {
        // Get the string from NSDate object.
        let formatter = NSDateFormatter()
        formatter.dateFormat = "H:mm"
        // Split the string into string array.
        let timeStr = formatter.stringFromDate(self)
        let timeArr = timeStr.componentsSeparatedByString(":")
        var s : Int = 0
        if let h : String = timeArr[0]{
            if let m : String = timeArr[1]{
                s = (Int(h)! * 60 + Int(m)!) * 60
            }
        }
        return s
    }
}