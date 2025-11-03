//
//  Vaccine.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Represents a vaccine record for a pet
struct Vaccine: Identifiable, Codable {
    let id: UUID
    var petId: UUID
    var name: String
    var vaccineType: VaccineType
    var administeredDate: Date
    var nextDueDate: Date?
    var administeredBy: String? // Vet name or clinic
    var batchNumber: String?
    var notes: String?
    var isRequired: Bool
    var isCompleted: Bool
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Computed Properties
    var isOverdue: Bool {
        guard let nextDueDate = nextDueDate, !isCompleted else { return false }
        return nextDueDate < Date()
    }

    var daysUntilNext: Int? {
        guard let nextDueDate = nextDueDate else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: nextDueDate)
        return components.day
    }

    var status: VaccineStatus {
        if isCompleted {
            return .completed
        } else if isOverdue {
            return .overdue
        } else if let days = daysUntilNext, days <= 7 {
            return .dueSoon
        } else {
            return .upcoming
        }
    }

    // MARK: - Initialization
    init(id: UUID = UUID(),
         petId: UUID,
         name: String,
         vaccineType: VaccineType,
         administeredDate: Date,
         nextDueDate: Date? = nil,
         administeredBy: String? = nil,
         batchNumber: String? = nil,
         notes: String? = nil,
         isRequired: Bool = true) {
        self.id = id
        self.petId = petId
        self.name = name
        self.vaccineType = vaccineType
        self.administeredDate = administeredDate
        self.nextDueDate = nextDueDate
        self.administeredBy = administeredBy
        self.batchNumber = batchNumber
        self.notes = notes
        self.isRequired = isRequired
        self.isCompleted = true
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - Enums
enum VaccineType: String, Codable, CaseIterable {
    case rabies = "Kuduz"
    case distemper = "Karma"
    case parvovirus = "Parvovirüs"
    case bordetella = "Bordetella"
    case leptospirosis = "Leptospiroz"
    case felineLeukemia = "Kedi Lösemisi"
    case felineHerpesvirus = "Kedi Herpes Virüsü"
    case felineCalicivirus = "Kedi Calici Virüsü"
    case other = "Diğer"

    var displayName: String {
        rawValue
    }

    var applicablePetTypes: [PetType] {
        switch self {
        case .rabies, .distemper, .parvovirus, .bordetella, .leptospirosis:
            return [.dog]
        case .felineLeukemia, .felineHerpesvirus, .felineCalicivirus:
            return [.cat]
        case .other:
            return PetType.allCases
        }
    }
}

enum VaccineStatus: String, Codable {
    case completed = "Tamamlandı"
    case upcoming = "Yaklaşan"
    case dueSoon = "Yakında"
    case overdue = "Gecikmiş"

    var colorName: String {
        switch self {
        case .completed: return "green"
        case .upcoming: return "blue"
        case .dueSoon: return "orange"
        case .overdue: return "red"
        }
    }

    var iconName: String {
        switch self {
        case .completed: return "checkmark.circle.fill"
        case .upcoming: return "calendar.circle.fill"
        case .dueSoon: return "exclamationmark.triangle.fill"
        case .overdue: return "xmark.circle.fill"
        }
    }
}
