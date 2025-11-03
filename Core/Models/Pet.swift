//
//  Pet.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Represents a pet in the PetCare application
struct Pet: Identifiable, Codable {
    let id: UUID
    var name: String
    var type: PetType
    var breed: String?
    var birthDate: Date?
    var weight: Double?
    var imageData: Data?
    var isActive: Bool
    var createdAt: Date
    var updatedAt: Date

    // MARK: - Computed Properties
    var age: Int? {
        guard let birthDate = birthDate else { return nil }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: Date())
        return ageComponents.year
    }

    var ageInMonths: Int? {
        guard let birthDate = birthDate else { return nil }
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.month], from: birthDate, to: Date())
        return ageComponents.month
    }

    // MARK: - Initialization
    init(id: UUID = UUID(),
         name: String,
         type: PetType,
         breed: String? = nil,
         birthDate: Date? = nil,
         weight: Double? = nil,
         imageData: Data? = nil,
         isActive: Bool = true) {
        self.id = id
        self.name = name
        self.type = type
        self.breed = breed
        self.birthDate = birthDate
        self.weight = weight
        self.imageData = imageData
        self.isActive = isActive
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

// MARK: - PetType Enum
enum PetType: String, Codable, CaseIterable {
    case dog = "Köpek"
    case cat = "Kedi"
    case bird = "Kuş"
    case fish = "Balık"
    case rabbit = "Tavşan"
    case hamster = "Hamster"
    case other = "Diğer"

    var iconName: String {
        switch self {
        case .dog: return "pawprint.fill"
        case .cat: return "cat.fill"
        case .bird: return "bird.fill"
        case .fish: return "fish.fill"
        case .rabbit: return "hare.fill"
        case .hamster: return "circle.fill"
        case .other: return "questionmark.circle.fill"
        }
    }

    var displayName: String {
        return self.rawValue
    }
}
