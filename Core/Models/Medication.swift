//
//  Medication.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Represents a medication record for a pet
struct Medication: Identifiable, Codable {
    let id: UUID
    var petId: UUID
    var name: String
    var dosage: String
    var frequency: MedicationFrequency
    var startDate: Date
    var endDate: Date?
    var instructions: String?
    var prescribedBy: String? // Vet name
    var isActive: Bool
    var isCompleted: Bool
    var nextDoseDate: Date?
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Computed Properties
    var isOverdue: Bool {
        guard let nextDoseDate = nextDoseDate, isActive else { return false }
        return nextDoseDate < Date()
    }

    var daysRemaining: Int? {
        guard let endDate = endDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: endDate)
        return max(0, components.day ?? 0)
    }

    var status: MedicationStatus {
        if !isActive {
            return .inactive
        } else if isCompleted {
            return .completed
        } else if isOverdue {
            return .overdue
        } else if let days = daysRemaining, days <= 3 {
            return .endingSoon
        } else {
            return .active
        }
    }

    // MARK: - Initialization
    init(id: UUID = UUID(),
         petId: UUID,
         name: String,
         dosage: String,
         frequency: MedicationFrequency,
         startDate: Date,
         endDate: Date? = nil,
         instructions: String? = nil,
         prescribedBy: String? = nil,
         isActive: Bool = true) {
        self.id = id
        self.petId = petId
        self.name = name
        self.dosage = dosage
        self.frequency = frequency
        self.startDate = startDate
        self.endDate = endDate
        self.instructions = instructions
        self.prescribedBy = prescribedBy
        self.isActive = isActive
        self.isCompleted = false
        self.nextDoseDate = frequency.calculateNextDose(from: startDate)
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Enums
enum MedicationFrequency: String, Codable, CaseIterable {
    case onceDaily = "Günde bir kez"
    case twiceDaily = "Günde iki kez"
    case threeTimesDaily = "Günde üç kez"
    case everyOtherDay = "İki günde bir"
    case weekly = "Haftalık"
    case monthly = "Aylık"
    case asNeeded = "Gerektiğinde"
    case custom = "Özel"

    var displayName: String {
        rawValue
    }

    func calculateNextDose(from date: Date) -> Date? {
        let calendar = Calendar.current
        switch self {
        case .onceDaily:
            return calendar.date(byAdding: .day, value: 1, to: date)
        case .twiceDaily:
            return calendar.date(byAdding: .hour, value: 12, to: date)
        case .threeTimesDaily:
            return calendar.date(byAdding: .hour, value: 8, to: date)
        case .everyOtherDay:
            return calendar.date(byAdding: .day, value: 2, to: date)
        case .weekly:
            return calendar.date(byAdding: .weekOfYear, value: 1, to: date)
        case .monthly:
            return calendar.date(byAdding: .month, value: 1, to: date)
        case .asNeeded:
            return nil // No next dose for as-needed medications
        case .custom:
            return nil // Would need custom logic
        }
    }
}

enum MedicationStatus: String, Codable {
    case active = "Aktif"
    case completed = "Tamamlandı"
    case overdue = "Gecikmiş"
    case endingSoon = "Bitmek üzere"
    case inactive = "Pasif"

    var colorName: String {
        switch self {
        case .active: return "green"
        case .completed: return "blue"
        case .overdue: return "red"
        case .endingSoon: return "orange"
        case .inactive: return "gray"
        }
    }

    var iconName: String {
        switch self {
        case .active: return "pills.fill"
        case .completed: return "checkmark.circle.fill"
        case .overdue: return "exclamationmark.triangle.fill"
        case .endingSoon: return "clock.fill"
        case .inactive: return "circle.fill"
        }
    }
}
