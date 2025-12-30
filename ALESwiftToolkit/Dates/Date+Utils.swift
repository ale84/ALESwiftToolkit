//  Created by Alessio Orlando on 13/03/18.
//  Copyright © 2025 Alessio Orlando. All rights reserved.
//

// Mostly grabbed from https://github.com/melvitax/DateHelper

import Foundation

extension Date {
    func addingDays(_ days: Int) -> Date? {
        let calendar = Calendar.current
        let components = DateComponents(calendar: calendar, day: days)
        let newDate = calendar.date(byAdding: components, to: self)
        return newDate
    }
    
    func isSameDay(as date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: self)
        let otherComponents = calendar.dateComponents([.year, .month, .day], from: date)
        return components.year == otherComponents.year
            && components.month == otherComponents.month
            && components.day == otherComponents.day
    }
    
    func daysSince(_ date: Date) -> Int {
        let calendar = Calendar.current
        let end = calendar.ordinality(of: .day, in: .era, for: self)
        let start = calendar.ordinality(of: .day, in: .era, for: date)
        return end! - start!
    }
    
    var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: self)
    }
    
    var monthName: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.month], from: self)
        let dateFormatter = DateFormatter()
        return dateFormatter.standaloneMonthSymbols[components.month! - 1]
    }
    
    func dateFor(_ type:DateForType, calendar:Calendar = Calendar.current) -> Date {
        switch type {
        case .startOfDay:
            return adjust(hour: 0, minute: 0, second: 0)
        case .endOfDay:
            return adjust(hour: 23, minute: 59, second: 59)
        case .startOfWeek:
            return calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!
        case .endOfWeek:
            let offset = 7 - component(.weekday)!
            return adjust(.day, offset: offset)
        case .startOfMonth:
            return adjust(hour: 0, minute: 0, second: 0, day: 1)
        case .endOfMonth:
            let month = (component(.month) ?? 0) + 1
            return adjust(hour: 0, minute: 0, second: 0, day: 0, month: month)
        case .startOfYear:
            return adjust(hour: 0, minute: 0, second: 0, day: 1, month: 1)
        case .tomorrow:
            return adjust(.day, offset:1)
        case .yesterday:
            return adjust(.day, offset:-1)
        case .nearestMinute(let nearest):
            let minutes = (component(.minute)! + nearest/2) / nearest * nearest
            return adjust(hour: nil, minute: minutes, second: nil)
        case .nearestHour(let nearest):
            let hours = (component(.hour)! + nearest/2) / nearest * nearest
            return adjust(hour: hours, minute: 0, second: nil)
        }
    }
    
    // MARK: Extracting components
    
    func component(_ component:DateComponentType) -> Int? {
        let components = Date.components(self)
        switch component {
        case .second:
            return components.second
        case .minute:
            return components.minute
        case .hour:
            return components.hour
        case .day:
            return components.day
        case .weekday:
            return components.weekday
        case .nthWeekday:
            return components.weekdayOrdinal
        case .week:
            return components.weekOfYear
        case .month:
            return components.month
        case .year:
            return components.year
        }
    }
    
    func adjust(_ component:DateComponentType, offset:Int) -> Date {
        var dateComp = DateComponents()
        switch component {
        case .second:
            dateComp.second = offset
        case .minute:
            dateComp.minute = offset
        case .hour:
            dateComp.hour = offset
        case .day:
            dateComp.day = offset
        case .weekday:
            dateComp.weekday = offset
        case .nthWeekday:
            dateComp.weekdayOrdinal = offset
        case .week:
            dateComp.weekOfYear = offset
        case .month:
            dateComp.month = offset
        case .year:
            dateComp.year = offset
        }
        return Calendar.current.date(byAdding: dateComp, to: self)!
    }
    
    /// Compares dates to see if they are equal while ignoring time.
    func compare(_ comparison:DateComparisonType) -> Bool {
        switch comparison {
        case .isToday:
            return compare(.isSameDay(as: Date()))
        case .isTomorrow:
            let comparison = Date().adjust(.day, offset:1)
            return compare(.isSameDay(as: comparison))
        case .isYesterday:
            let comparison = Date().adjust(.day, offset: -1)
            return compare(.isSameDay(as: comparison))
        case .isSameDay(let date):
            return component(.year) == date.component(.year)
                && component(.month) == date.component(.month)
                && component(.day) == date.component(.day)
        case .isThisWeek:
            return self.compare(.isSameWeek(as: Date()))
        case .isNextWeek:
            let comparison = Date().adjust(.week, offset:1)
            return compare(.isSameWeek(as: comparison))
        case .isLastWeek:
            let comparison = Date().adjust(.week, offset:-1)
            return compare(.isSameWeek(as: comparison))
        case .isSameWeek(let date):
            if component(.week) != date.component(.week) {
                return false
            }
            // Ensure time interval is under 1 week
            return abs(self.timeIntervalSince(date)) < Date.weekInSeconds
        case .isThisMonth:
            return self.compare(.isSameMonth(as: Date()))
        case .isNextMonth:
            let comparison = Date().adjust(.month, offset:1)
            return compare(.isSameMonth(as: comparison))
        case .isLastMonth:
            let comparison = Date().adjust(.month, offset:-1)
            return compare(.isSameMonth(as: comparison))
        case .isSameMonth(let date):
            return component(.year) == date.component(.year) && component(.month) == date.component(.month)
        case .isThisYear:
            return self.compare(.isSameYear(as: Date()))
        case .isNextYear:
            let comparison = Date().adjust(.year, offset:1)
            return compare(.isSameYear(as: comparison))
        case .isLastYear:
            let comparison = Date().adjust(.year, offset:-1)
            return compare(.isSameYear(as: comparison))
        case .isSameYear(let date):
            return component(.year) == date.component(.year)
        case .isInTheFuture:
            return self.compare(.isLater(than: Date()))
        case .isInThePast:
            return self.compare(.isEarlier(than: Date()))
        case .isEarlier(let date):
            return (self as NSDate).earlierDate(date) == self
        case .isLater(let date):
            return (self as NSDate).laterDate(date) == self
        case .isWeekday:
            return !compare(.isWeekend)
        case .isWeekend:
            let range = Calendar.current.maximumRange(of: Calendar.Component.weekday)!
            return (component(.weekday) == range.lowerBound || component(.weekday) == range.upperBound - range.lowerBound)
        }
    }
    
    /// Return a new Date object with the new hour, minute and seconds values.
    func adjust(hour: Int?, minute: Int?, second: Int?, day: Int? = nil, month: Int? = nil) -> Date {
        var comp = Date.components(self)
        comp.month = month ?? comp.month
        comp.day = day ?? comp.day
        comp.hour = hour ?? comp.hour
        comp.minute = minute ?? comp.minute
        comp.second = second ?? comp.second
        return Calendar.current.date(from: comp)!
    }
    
    static func componentFlags() -> Set<Calendar.Component> { return [Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.weekOfYear, Calendar.Component.hour, Calendar.Component.minute, Calendar.Component.second, Calendar.Component.weekday, Calendar.Component.weekdayOrdinal, Calendar.Component.weekOfYear] }
    
    static func components(_ fromDate: Date) -> DateComponents {
        return Calendar.current.dateComponents(Date.componentFlags(), from: fromDate)
    }
    
    static let weekInSeconds:Double = 604800
}

// The type of date that can be used for the dateFor function.
enum DateForType {
    case startOfDay, endOfDay, startOfWeek, endOfWeek, startOfMonth, endOfMonth, startOfYear, tomorrow, yesterday, nearestMinute(minute:Int), nearestHour(hour:Int)
}

// The date components available to be retrieved or modifed
public enum DateComponentType {
    case second, minute, hour, day, weekday, nthWeekday, week, month, year
}

// The type of comparison to do against today's date or with the suplied date.
public enum DateComparisonType {
    
    // Days
    
    /// Checks if date today.
    case isToday
    /// Checks if date is tomorrow.
    case isTomorrow
    /// Checks if date is yesterday.
    case isYesterday
    /// Compares date days
    case isSameDay(as:Date)
    
    // Weeks
    
    /// Checks if date is in this week.
    case isThisWeek
    /// Checks if date is in next week.
    case isNextWeek
    /// Checks if date is in last week.
    case isLastWeek
    /// Compares date weeks
    case isSameWeek(as:Date)
    
    // Months
    
    /// Checks if date is in this month.
    case isThisMonth
    /// Checks if date is in next month.
    case isNextMonth
    /// Checks if date is in last month.
    case isLastMonth
    /// Compares date months
    case isSameMonth(as:Date)
    
    // Years
    
    /// Checks if date is in this year.
    case isThisYear
    /// Checks if date is in next year.
    case isNextYear
    /// Checks if date is in last year.
    case isLastYear
    /// Compare date years
    case isSameYear(as:Date)
    
    // Relative Time
    
    /// Checks if it's a future date
    case isInTheFuture
    /// Checks if the date has passed
    case isInThePast
    /// Checks if earlier than date
    case isEarlier(than:Date)
    /// Checks if later than date
    case isLater(than:Date)
    /// Checks if it's a weekday
    case isWeekday
    /// Checks if it's a weekend
    case isWeekend
    
}

