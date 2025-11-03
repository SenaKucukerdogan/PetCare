//
//  Color+Extensions.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

extension Color {
    // MARK: - App Colors

    /// Primary brand color
    static let appPrimary = Color("AccentColor")

    /// Secondary color for accents
    static let appSecondary = Color.secondary

    /// Success color for positive actions
    static let success = Color.green

    /// Warning color for caution states
    static let warning = Color.orange

    /// Error color for destructive actions
    static let error = Color.red

    /// Background color for cards and surfaces
    static let cardBackground = Color(.systemBackground)

    /// Secondary background color
    static let secondaryBackground = Color(.secondarySystemBackground)

    // MARK: - Task Category Colors

    /// Color for feeding tasks
    static let feedingColor = Color.orange

    /// Color for walking tasks
    static let walkingColor = Color.green

    /// Color for grooming tasks
    static let groomingColor = Color.purple

    /// Color for vet tasks
    static let vetColor = Color.red

    /// Color for medication tasks
    static let medicationColor = Color.blue

    /// Color for training tasks
    static let trainingColor = Color.yellow

    /// Color for cleaning tasks
    static let cleaningColor = Color.gray

    /// Color for other tasks
    static let otherColor = Color.secondary

    // MARK: - Priority Colors

    /// Color for urgent priority
    static let urgentPriority = Color.red

    /// Color for high priority
    static let highPriority = Color.orange

    /// Color for medium priority
    static let mediumPriority = Color.yellow

    /// Color for low priority
    static let lowPriority = Color.green

    // MARK: - Status Colors

    /// Color for completed status
    static let completedStatus = Color.green

    /// Color for overdue status
    static let overdueStatus = Color.red

    /// Color for due soon status
    static let dueSoonStatus = Color.orange

    /// Color for upcoming status
    static let upcomingStatus = Color.blue

    // MARK: - Utility Colors

    /// Light gray for borders and dividers
    static let border = Color(.systemGray4)

    /// Very light gray for subtle backgrounds
    static let subtleBackground = Color(.systemGray6)

    /// Color for disabled states
    static let disabled = Color(.systemGray)

    // MARK: - Dynamic Colors

    /// Adaptive text color based on color scheme
    static var adaptiveText: Color {
        Color.primary
    }

    /// Adaptive secondary text color
    static var adaptiveSecondaryText: Color {
        Color.secondary
    }

    /// Adaptive background color
    static var adaptiveBackground: Color {
        Color(.systemBackground)
    }

    /// Adaptive secondary background color
    static var adaptiveSecondaryBackground: Color {
        Color(.secondarySystemBackground)
    }

    /// Adaptive grouped background color
    static var adaptiveGroupedBackground: Color {
        Color(.systemGroupedBackground)
    }

    // MARK: - Color from Task Category

    /// Get color for task category
    static func color(for category: TaskCategory) -> Color {
        switch category {
        case .feeding: return .feedingColor
        case .walking: return .walkingColor
        case .grooming: return .groomingColor
        case .vet: return .vetColor
        case .medication: return .medicationColor
        case .training: return .trainingColor
        case .cleaning: return .cleaningColor
        case .other: return .otherColor
        }
    }

    // MARK: - Color from Task Priority

    /// Get color for task priority
    static func color(for priority: TaskPriority) -> Color {
        switch priority {
        case .urgent: return .urgentPriority
        case .high: return .highPriority
        case .medium: return .mediumPriority
        case .low: return .lowPriority
        }
    }

    // MARK: - Color from Vaccine Status

    /// Get color for vaccine status
    static func color(for status: VaccineStatus) -> Color {
        switch status {
        case .completed: return .completedStatus
        case .upcoming: return .upcomingStatus
        case .dueSoon: return .dueSoonStatus
        case .overdue: return .overdueStatus
        }
    }

    // MARK: - Color from Medication Status

    /// Get color for medication status
    static func color(for status: MedicationStatus) -> Color {
        switch status {
        case .active: return .success
        case .completed: return .completedStatus
        case .overdue: return .overdueStatus
        case .endingSoon: return .dueSoonStatus
        case .inactive: return .disabled
        }
    }

    // MARK: - Hex Color Support

    /// Create color from hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    /// Convert color to hex string
    var hexString: String {
        let components = self.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
        return hexString
    }
}
