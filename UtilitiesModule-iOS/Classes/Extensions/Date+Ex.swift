//
//  Date+Ex.swift
//  UtilitiesModule-iOS
//
//  Created by ITD-Latt Chanon on 26/12/24.
//

import Foundation

// MARK: - Generate

public extension Date {
    
    static var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    static func getCurrentDay() -> Int {
        return Calendar.current.component(.day, from: Date())
    }

    static func getCurrentMonth() -> Int {
        return Calendar.current.component(.month, from: Date())
    }

    static func getCurrentDayLength() -> Int {
        return String(getCurrentDay()).count
    }

    static func getCurrentMonthLength() -> Int {
        return String(getCurrentMonth()).count
    }

    static func getCurrentYear() -> Int {
        return Calendar.current.component(.year, from: Date())
    }
    
    func hour() -> Double {
        //Get Hour
        let calendar = NSCalendar.current
        let components =  calendar.component(.hour, from: self as Date)
        let hour = components.toDouble
        
        //Return Hour
        return hour
    }
    
    
    func minute() -> Double
    {
        //Get Minute
        let calendar = NSCalendar.current
        let components = calendar.component(.minute, from: self as Date)
        let minute = components.toDouble
        
        
        //Return Minute
        return minute
    }
    
    func second() -> Double
    {
        //Get Minute
        let calendar = NSCalendar.current
        let components = calendar.component(.second, from: self as Date)
        let seconds = components.toDouble
        
        
        //Return Minute
        return seconds
    }
    
    func daySuffix() -> String {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components(.day, from: self)
        let dayOfMonth = components.day
        switch dayOfMonth {
        case 1, 21, 31:
            return "st"
        case 2, 22:
            return "nd"
        case 3, 23:
            return "rd"
        default:
            return "th"
        }
    }
}

// MARK: - Date Format

extension Date {
    
    func dateFormatWithSuffix(withYear: Bool) -> String {
        if withYear {
            return "dd'\(self.daySuffix())' MMM-yyyy"
        } else {
            return "dd'\(self.daySuffix())' MMM"
        }
    }
    
    func getFormattedDate(isWithYear: Bool) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = self.dateFormatWithSuffix(withYear: isWithYear)
        return dateFormatter.string(from: self)
    }
    
    func toShortTimeString() -> String
    {
        //Get Short Time String
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let timeString = formatter.string(from: self)
        
        //Return Short Time String
        return timeString
    }
}
