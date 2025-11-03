//
//  Reminder.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Represents a reminder notification for pet care activities
struct Reminder: Identifiable, Codable {
    let id: UUID
    var title: String
    var message: String?
    var petId: UUID?
    var taskId: UUID?
    var scheduledDate: Date
    var isRepeating: Bool
    var repeatInterval: TimeInterval? // In seconds
    var repeatType: RepeatType?
    var isEnabled: Bool
    var notificationId: String? // For system notification management
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Computed Properties
    var isPastDue: Bool {
        scheduledDate < Date() && isEnabled
    }

    var nextTriggerDate: Date? {
        guard isRepeating, let interval = repeatInterval else {
            return isEnabled ? scheduledDate : nil
        }

        let now = Date()
        var nextDate = scheduledDate

        while nextDate <= now {
            nextDate = nextDate.addingTimeInterval(interval)
        }

        return nextDate
    }

    // MARK: - Initialization
    init(id: UUID = UUID(),
         title: String,
         message: String? = nil,
         petId: UUID? = nil,
         taskId: UUID? = nil,
         scheduledDate: Date,
         isRepeating: Bool = false,
         repeatInterval: TimeInterval? = nil,
         repeatType: RepeatType? = nil,
         isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.message = message
        self.petId = petId
        self.taskId = taskId
        self.scheduledDate = scheduledDate
        self.isRepeating = isRepeating
        self.repeatInterval = repeatInterval
        self.repeatType = repeatType
        self.isEnabled = isEnabled
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - RepeatType Enum
enum RepeatType: String, Codable, CaseIterable {
    case hourly = "Saatlik"
    case daily = "Günlük"
    case weekly = "Haftalık"
    case monthly = "Aylık"
    case yearly = "Yıllık"

    var timeInterval: TimeInterval {
        switch self {
        case .hourly: return 3600 // 1 hour
        case .daily: return 86400 // 24 hours
        case .weekly: return 604800 // 7 days
        case .monthly: return 2592000 // 30 days (approximate)
        case .yearly: return 31536000 // 365 days (approximate)
        }
    }

    var displayName: String {
        rawValue
    }
}
