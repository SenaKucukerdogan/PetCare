//
//  Date+Extensions.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

extension Date {
    // MARK: - Formatting

    /// Format date as short date string (e.g., "25.11.2025")
    var shortDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: self)
    }

    /// Format date as medium date string (e.g., "25 Kas 2025")
    var mediumDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: self)
    }

    /// Format date as long date string
    var longDateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: self)
    }

    /// Format time as short time string (e.g., "14:30")
    var shortTimeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "tr_TR")
        return formatter.string(from: self)
    }

    /// Format as relative date string (e.g., "Bugün", "Dün", "2 gün önce")
    var relativeDateString: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day, .weekOfYear, .month, .year], from: self, to: now)

        if let year = components.year, year > 0 {
            return "\(year) yıl önce"
        } else if let month = components.month, month > 0 {
            return "\(month) ay önce"
        } else if let week = components.weekOfYear, week > 0 {
            return "\(week) hafta önce"
        } else if let day = components.day {
            switch day {
            case 0:
                return "Bugün"
            case 1:
                return "Dün"
            case 2...6:
                return "\(day) gün önce"
            default:
                return shortDateString
            }
        }

        return shortDateString
    }

    /// Format as relative time string (e.g., "5 dakika önce")
    var relativeTimeString: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: self, to: now)

        if let day = components.day, day > 0 {
            return relativeDateString
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) saat önce"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) dakika önce"
        } else if let second = components.second, second > 30 {
            return "\(second) saniye önce"
        } else {
            return "Şimdi"
        }
    }

    // MARK: - Date Calculations

    /// Start of day for this date
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    /// End of day for this date
    var endOfDay: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfDay) ?? self
    }

    /// Start of week for this date
    var startOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components) ?? self
    }

    /// Start of month for this date
    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? self
    }

    /// Age in years from this date to now
    var age: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: Date())
        return ageComponents.year ?? 0
    }

    /// Age in months from this date to now
    var ageInMonths: Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.month], from: self, to: Date())
        return ageComponents.month ?? 0
    }

    /// Is this date today?
    var isToday: Bool {
        Calendar.current.isDateInToday(self)
    }

    /// Is this date yesterday?
    var isYesterday: Bool {
        Calendar.current.isDateInYesterday(self)
    }

    /// Is this date in the future?
    var isFuture: Bool {
        self > Date()
    }

    /// Is this date in the past?
    var isPast: Bool {
        self < Date()
    }

    // MARK: - Date Arithmetic

    /// Add days to this date
    func adding(days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: days, to: self) ?? self
    }

    /// Add weeks to this date
    func adding(weeks: Int) -> Date {
        Calendar.current.date(byAdding: .weekOfYear, value: weeks, to: self) ?? self
    }

    /// Add months to this date
    func adding(months: Int) -> Date {
        Calendar.current.date(byAdding: .month, value: months, to: self) ?? self
    }

    /// Add years to this date
    func adding(years: Int) -> Date {
        Calendar.current.date(byAdding: .year, value: years, to: self) ?? self
    }

    // MARK: - Weekday Information

    /// Day of week (1 = Sunday, 7 = Saturday)
    var weekday: Int {
        Calendar.current.component(.weekday, from: self)
    }

    /// Weekday name
    var weekdayName: String {
        let weekdayNames = ["Pazar", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"]
        return weekdayNames[weekday - 1]
    }

    /// Weekday name (short)
    var weekdayNameShort: String {
        let weekdayNames = ["Paz", "Pzt", "Sal", "Çar", "Per", "Cum", "Cmt"]
        return weekdayNames[weekday - 1]
    }

    // MARK: - Time Components

    /// Hour component
    var hour: Int {
        Calendar.current.component(.hour, from: self)
    }

    /// Minute component
    var minute: Int {
        Calendar.current.component(.minute, from: self)
    }

    /// Second component
    var second: Int {
        Calendar.current.component(.second, from: self)
    }
}
