//
//  DateHelper.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Helper class for date-related operations
class DateHelper {
    static let shared = DateHelper()

    private let calendar: Calendar
    private let dateFormatter: DateFormatter

    private init() {
        self.calendar = Calendar.current
        self.dateFormatter = DateFormatter()
        self.dateFormatter.locale = Locale(identifier: "tr_TR")
    }

    // MARK: - Date Formatting

    /// Format date to string with specified format
    func formatDate(_ date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }

    /// Format date to short date string
    func shortDateString(from date: Date) -> String {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    /// Format date to medium date string
    func mediumDateString(from date: Date) -> String {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    /// Format date to long date string
    func longDateString(from date: Date) -> String {
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }

    /// Format time to string
    func timeString(from date: Date) -> String {
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    /// Format date and time to string
    func dateTimeString(from date: Date) -> String {
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }

    // MARK: - Date Calculations

    /// Calculate age in years
    func ageInYears(from birthDate: Date, to date: Date = Date()) -> Int {
        let components = calendar.dateComponents([.year], from: birthDate, to: date)
        return components.year ?? 0
    }

    /// Calculate age in months
    func ageInMonths(from birthDate: Date, to date: Date = Date()) -> Int {
        let components = calendar.dateComponents([.month], from: birthDate, to: date)
        return components.month ?? 0
    }

    /// Calculate days between two dates
    func daysBetween(startDate: Date, endDate: Date) -> Int {
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return components.day ?? 0
    }

    /// Calculate hours between two dates
    func hoursBetween(startDate: Date, endDate: Date) -> Int {
        let components = calendar.dateComponents([.hour], from: startDate, to: endDate)
        return components.hour ?? 0
    }

    /// Calculate minutes between two dates
    func minutesBetween(startDate: Date, endDate: Date) -> Int {
        let components = calendar.dateComponents([.minute], from: startDate, to: endDate)
        return components.minute ?? 0
    }

    // MARK: - Date Comparisons

    /// Check if date is today
    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    /// Check if date is yesterday
    func isYesterday(_ date: Date) -> Bool {
        calendar.isDateInYesterday(date)
    }

    /// Check if date is tomorrow
    func isTomorrow(_ date: Date) -> Bool {
        calendar.isDateInTomorrow(date)
    }

    /// Check if date is in the future
    func isFuture(_ date: Date) -> Bool {
        date > Date()
    }

    /// Check if date is in the past
    func isPast(_ date: Date) -> Bool {
        date < Date()
    }

    /// Check if two dates are on the same day
    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }

    /// Check if date is within a date range
    func isDate(_ date: Date, inRange range: ClosedRange<Date>) -> Bool {
        range.contains(date)
    }

    // MARK: - Date Arithmetic

    /// Add days to date
    func addDays(_ days: Int, to date: Date) -> Date {
        calendar.date(byAdding: .day, value: days, to: date) ?? date
    }

    /// Add weeks to date
    func addWeeks(_ weeks: Int, to date: Date) -> Date {
        calendar.date(byAdding: .weekOfYear, value: weeks, to: date) ?? date
    }

    /// Add months to date
    func addMonths(_ months: Int, to date: Date) -> Date {
        calendar.date(byAdding: .month, value: months, to: date) ?? date
    }

    /// Add years to date
    func addYears(_ years: Int, to date: Date) -> Date {
        calendar.date(byAdding: .year, value: years, to: date) ?? date
    }

    // MARK: - Week Operations

    /// Get start of week for date
    func startOfWeek(for date: Date) -> Date {
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return calendar.date(from: components) ?? date
    }

    /// Get end of week for date
    func endOfWeek(for date: Date) -> Date {
        let startOfWeek = startOfWeek(for: date)
        return calendar.date(byAdding: .day, value: 6, to: startOfWeek) ?? date
    }

    /// Get weekday name for date
    func weekdayName(for date: Date) -> String {
        let weekdayNames = ["Pazar", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"]
        let weekday = calendar.component(.weekday, from: date)
        return weekdayNames[weekday - 1]
    }

    /// Get short weekday name for date
    func shortWeekdayName(for date: Date) -> String {
        let weekdayNames = ["Paz", "Pzt", "Sal", "Çar", "Per", "Cum", "Cmt"]
        let weekday = calendar.component(.weekday, from: date)
        return weekdayNames[weekday - 1]
    }

    // MARK: - Month Operations

    /// Get start of month for date
    func startOfMonth(for date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }

    /// Get end of month for date
    func endOfMonth(for date: Date) -> Date {
        let startOfMonth = startOfMonth(for: date)
        return calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) ?? date
    }

    /// Get month name for date
    func monthName(for date: Date) -> String {
        let monthNames = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
                         "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"]
        let month = calendar.component(.month, from: date)
        return monthNames[month - 1]
    }

    /// Get short month name for date
    func shortMonthName(for date: Date) -> String {
        let monthNames = ["Oca", "Şub", "Mar", "Nis", "May", "Haz",
                         "Tem", "Ağu", "Eyl", "Eki", "Kas", "Ara"]
        let month = calendar.component(.month, from: date)
        return monthNames[month - 1]
    }

    // MARK: - Time Components

    /// Get hour from date
    func hour(from date: Date) -> Int {
        calendar.component(.hour, from: date)
    }

    /// Get minute from date
    func minute(from date: Date) -> Int {
        calendar.component(.minute, from: date)
    }

    /// Get second from date
    func second(from date: Date) -> Int {
        calendar.component(.second, from: date)
    }

    // MARK: - Relative Date Strings

    /// Get relative date string (e.g., "Bugün", "Dün", "2 gün önce")
    func relativeDateString(for date: Date) -> String {
        if isToday(date) {
            return "Bugün"
        } else if isYesterday(date) {
            return "Dün"
        } else if isTomorrow(date) {
            return "Yarın"
        } else {
            let days = abs(daysBetween(startDate: date, endDate: Date()))
            if days <= 6 {
                return "\(days) gün önce"
            } else {
                return shortDateString(from: date)
            }
        }
    }

    /// Get relative time string (e.g., "5 dakika önce")
    func relativeTimeString(for date: Date) -> String {
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: now)

        if let day = components.day, day > 0 {
            return relativeDateString(for: date)
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

    // MARK: - Date Ranges

    /// Get date range for current week
    func currentWeekRange() -> ClosedRange<Date> {
        let start = startOfWeek(for: Date())
        let end = endOfWeek(for: Date())
        return start...end
    }

    /// Get date range for current month
    func currentMonthRange() -> ClosedRange<Date> {
        let start = startOfMonth(for: Date())
        let end = endOfMonth(for: Date())
        return start...end
    }

    /// Get date range for last N days
    func lastNDaysRange(_ days: Int) -> ClosedRange<Date> {
        let end = Date()
        let start = addDays(-days, to: end)
        return start...end
    }
}
