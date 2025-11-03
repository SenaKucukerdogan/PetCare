//
//  Task.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Represents a task for pet care
struct Task: Identifiable, Codable {
    let id: UUID
    var title: String
    var description: String?
    var category: TaskCategory
    var priority: TaskPriority
    var petId: UUID?
    var dueDate: Date?
    var isCompleted: Bool
    var isRecurring: Bool
    var recurrenceType: RecurrenceType?
    var recurrenceInterval: Int? // Days for custom, weeks/months for others
    var nextDueDate: Date?
    var completedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Computed Properties
    var isOverdue: Bool {
        guard let dueDate = dueDate, !isCompleted else { return false }
        return dueDate < Date()
    }

    var daysUntilDue: Int? {
        guard let dueDate = dueDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: dueDate)
        return components.day
    }

    // MARK: - Initialization
    init(id: UUID = UUID(),
         title: String,
         description: String? = nil,
         category: TaskCategory,
         priority: TaskPriority = .medium,
         petId: UUID? = nil,
         dueDate: Date? = nil,
         isRecurring: Bool = false,
         recurrenceType: RecurrenceType? = nil,
         recurrenceInterval: Int? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.priority = priority
        self.petId = petId
        self.dueDate = dueDate
        self.isCompleted = false
        self.isRecurring = isRecurring
        self.recurrenceType = recurrenceType
        self.recurrenceInterval = recurrenceInterval
        self.nextDueDate = dueDate
        self.createdAt = Date()
        self.updatedAt = Date()
    }

    // MARK: - Methods
    mutating func markCompleted() {
        isCompleted = true
        completedAt = Date()
        updatedAt = Date()

        // Calculate next due date for recurring tasks
        if isRecurring, let recurrenceType = recurrenceType, let interval = recurrenceInterval {
            nextDueDate = calculateNextDueDate(from: dueDate ?? Date(), type: recurrenceType, interval: interval)
        }
    }

    private func calculateNextDueDate(from date: Date, type: RecurrenceType, interval: Int) -> Date {
        let calendar = Calendar.current
        switch type {
        case .daily:
            return calendar.date(byAdding: .day, value: interval, to: date) ?? date
        case .weekly:
            return calendar.date(byAdding: .weekOfYear, value: interval, to: date) ?? date
        case .monthly:
            return calendar.date(byAdding: .month, value: interval, to: date) ?? date
        case .yearly:
            return calendar.date(byAdding: .year, value: interval, to: date) ?? date
        case .custom:
            return calendar.date(byAdding: .day, value: interval, to: date) ?? date
        }
    }
}

// MARK: - Enums
enum TaskCategory: String, Codable, CaseIterable {
    case feeding = "Beslenme"
    case walking = "Yürüyüş"
    case grooming = "Bakım"
    case vet = "Veteriner"
    case medication = "İlaç"
    case training = "Eğitim"
    case cleaning = "Temizlik"
    case other = "Diğer"

    var iconName: String {
        switch self {
        case .feeding: return "fork.knife"
        case .walking: return "figure.walk"
        case .grooming: return "scissors"
        case .vet: return "stethoscope"
        case .medication: return "pills.fill"
        case .training: return "brain.head.profile"
        case .cleaning: return "sparkles"
        case .other: return "circle.fill"
        }
    }

    var colorName: String {
        switch self {
        case .feeding: return "orange"
        case .walking: return "green"
        case .grooming: return "purple"
        case .vet: return "red"
        case .medication: return "blue"
        case .training: return "yellow"
        case .cleaning: return "gray"
        case .other: return "secondary"
        }
    }
}

enum TaskPriority: String, Codable, CaseIterable {
    case low = "Düşük"
    case medium = "Orta"
    case high = "Yüksek"
    case urgent = "Acil"

    var colorName: String {
        switch self {
        case .low: return "green"
        case .medium: return "yellow"
        case .high: return "orange"
        case .urgent: return "red"
        }
    }
}

enum RecurrenceType: String, Codable, CaseIterable {
    case daily = "Günlük"
    case weekly = "Haftalık"
    case monthly = "Aylık"
    case yearly = "Yıllık"
    case custom = "Özel"

    var displayName: String {
        rawValue
    }
}
