//
//  Theme.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

/// Application theme configuration
struct Theme {
    // MARK: - Colors

    struct Colors {
        // Primary colors
        static let primary = Color.appPrimary
        static let secondary = Color.appSecondary

        // Semantic colors
        static let success = Color.success
        static let warning = Color.warning
        static let error = Color.error

        // Task category colors
        static let feeding = Color.feedingColor
        static let walking = Color.walkingColor
        static let grooming = Color.groomingColor
        static let vet = Color.vetColor
        static let medication = Color.medicationColor
        static let training = Color.trainingColor
        static let cleaning = Color.cleaningColor
        static let other = Color.otherColor

        // Priority colors
        static let urgent = Color.urgentPriority
        static let high = Color.highPriority
        static let medium = Color.mediumPriority
        static let low = Color.lowPriority

        // Status colors
        static let completed = Color.completedStatus
        static let overdue = Color.overdueStatus
        static let dueSoon = Color.dueSoonStatus
        static let upcoming = Color.upcomingStatus

        // UI element colors
        static let cardBackground = Color.cardBackground
        static let secondaryBackground = Color.secondaryBackground
        static let border = Color.border
        static let subtleBackground = Color.subtleBackground
        static let disabled = Color.disabled

        // Adaptive colors
        static let adaptiveText = Color.adaptiveText
        static let adaptiveSecondaryText = Color.adaptiveSecondaryText
        static let adaptiveBackground = Color.adaptiveBackground
        static let adaptiveSecondaryBackground = Color.adaptiveSecondaryBackground
        static let adaptiveGroupedBackground = Color.adaptiveGroupedBackground
    }

    // MARK: - Typography

    struct Typography {
        // Font sizes
        static let largeTitle: CGFloat = 34
        static let title1: CGFloat = 28
        static let title2: CGFloat = 22
        static let title3: CGFloat = 20
        static let headline: CGFloat = 17
        static let body: CGFloat = 17
        static let callout: CGFloat = 16
        static let subhead: CGFloat = 15
        static let footnote: CGFloat = 13
        static let caption1: CGFloat = 12
        static let caption2: CGFloat = 11

        // Font weights
        static let ultraLight = Font.Weight.ultraLight
        static let thin = Font.Weight.thin
        static let light = Font.Weight.light
        static let regular = Font.Weight.regular
        static let medium = Font.Weight.medium
        static let semibold = Font.Weight.semibold
        static let bold = Font.Weight.bold
        static let heavy = Font.Weight.heavy
        static let black = Font.Weight.black
    }

    // MARK: - Spacing

    struct Spacing {
        static let xxxs: CGFloat = 2
        static let xxs: CGFloat = 4
        static let xs: CGFloat = 8
        static let small: CGFloat = 12
        static let medium: CGFloat = 16
        static let large: CGFloat = 20
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 40
        static let huge: CGFloat = 48
    }

    // MARK: - Border Radius

    struct BorderRadius {
        static let none: CGFloat = 0
        static let small: CGFloat = 4
        static let medium: CGFloat = 8
        static let large: CGFloat = 12
        static let xl: CGFloat = 16
        static let xxl: CGFloat = 20
        static let full: CGFloat = 1000
    }

    // MARK: - Shadows

    struct Shadows {
        static let none = Shadow.none
        static let small = Shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        static let medium = Shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        static let large = Shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        static let xl = Shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 8)

        struct Shadow {
            let color: Color
            let radius: CGFloat
            let x: CGFloat
            let y: CGFloat

            static let none = Shadow(color: .clear, radius: 0, x: 0, y: 0)
        }
    }

    // MARK: - Animation

    struct Animation {
        static let fast: Double = 0.15
        static let normal: Double = 0.3
        static let slow: Double = 0.5

        static let springFast = Animation.spring(response: 0.3, dampingFraction: 0.8)
        static let springNormal = Animation.spring(response: 0.4, dampingFraction: 0.8)
        static let springSlow = Animation.spring(response: 0.6, dampingFraction: 0.7)

        static func spring(response: Double, dampingFraction: Double) -> SwiftUI.Animation {
            .spring(response: response, dampingFraction: dampingFraction)
        }

        static func easeInOut(duration: Double) -> SwiftUI.Animation {
            .easeInOut(duration: duration)
        }
    }

    // MARK: - Layout

    struct Layout {
        static let screenPadding: CGFloat = Spacing.medium
        static let cardPadding: CGFloat = Spacing.medium
        static let buttonHeight: CGFloat = 44
        static let inputHeight: CGFloat = 44
        static let iconSize: CGFloat = 24
        static let smallIconSize: CGFloat = 20
        static let largeIconSize: CGFloat = 32
        static let avatarSize: CGFloat = 40
        static let largeAvatarSize: CGFloat = 60

        // Grid layouts
        static let minColumnWidth: CGFloat = 300
        static let gridSpacing: CGFloat = Spacing.medium
    }
}

// MARK: - Theme Extensions

extension Color {
    // MARK: - Dynamic Color Resolution

    /// Get color for task category
    static func forCategory(_ category: TaskCategory) -> Color {
        Theme.Colors.feeding // Will be implemented based on category
    }

    /// Get color for priority
    static func forPriority(_ priority: TaskPriority) -> Color {
        switch priority {
        case .urgent: return Theme.Colors.urgent
        case .high: return Theme.Colors.high
        case .medium: return Theme.Colors.medium
        case .low: return Theme.Colors.low
        }
    }

    /// Get color for status
    static func forStatus(_ status: VaccineStatus) -> Color {
        switch status {
        case .completed: return Theme.Colors.completed
        case .upcoming: return Theme.Colors.upcoming
        case .dueSoon: return Theme.Colors.dueSoon
        case .overdue: return Theme.Colors.overdue
        }
    }
}

// MARK: - View Extensions for Theme

extension View {
    /// Apply theme spacing
    func themePadding(_ edges: Edge.Set = .all, _ spacing: CGFloat = Theme.Spacing.medium) -> some View {
        self.padding(edges, spacing)
    }

    /// Apply theme corner radius
    func themeCornerRadius(_ radius: CGFloat = Theme.BorderRadius.medium) -> some View {
        self.cornerRadius(radius)
    }

    /// Apply theme shadow
    func themeShadow(_ shadow: Theme.Shadows.Shadow = Theme.Shadows.medium) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }

    /// Apply theme animation
    func themeAnimation(_ animation: SwiftUI.Animation = .spring(response: 0.4, dampingFraction: 0.8)) -> some View {
        self.animation(animation, value: UUID())
    }
}

// MARK: - Font Extensions for Theme

extension Font {
    /// Theme typography
    static func themeLargeTitle() -> Font {
        .system(size: Theme.Typography.largeTitle, weight: .bold)
    }

    static func themeTitle1() -> Font {
        .system(size: Theme.Typography.title1, weight: .bold)
    }

    static func themeTitle2() -> Font {
        .system(size: Theme.Typography.title2, weight: .bold)
    }

    static func themeTitle3() -> Font {
        .system(size: Theme.Typography.title3, weight: .semibold)
    }

    static func themeHeadline() -> Font {
        .system(size: Theme.Typography.headline, weight: .semibold)
    }

    static func themeBody() -> Font {
        .system(size: Theme.Typography.body, weight: .regular)
    }

    static func themeCallout() -> Font {
        .system(size: Theme.Typography.callout, weight: .regular)
    }

    static func themeSubhead() -> Font {
        .system(size: Theme.Typography.subhead, weight: .regular)
    }

    static func themeFootnote() -> Font {
        .system(size: Theme.Typography.footnote, weight: .regular)
    }

    static func themeCaption1() -> Font {
        .system(size: Theme.Typography.caption1, weight: .regular)
    }

    static func themeCaption2() -> Font {
        .system(size: Theme.Typography.caption2, weight: .regular)
    }
}
