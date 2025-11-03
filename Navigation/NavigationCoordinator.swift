//
//  NavigationCoordinator.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

/// Coordinator for managing navigation state across the app
class NavigationCoordinator: ObservableObject {
    // MARK: - Published Properties
    @Published var currentRoute: AppRoute = .home
    @Published var navigationPath = NavigationPath()
    @Published var isOnboardingCompleted = false

    // MARK: - Private Properties
    private let persistenceService = PersistenceService.shared

    // MARK: - Initialization
    init() {
        checkOnboardingStatus()
    }

    // MARK: - Public Methods

    /// Navigate to a specific route
    func navigate(to route: AppRoute) {
        currentRoute = route
        navigationPath.append(route)
    }

    /// Navigate back
    func navigateBack() {
        navigationPath.removeLast()
        if let lastRoute = navigationPath.last {
            currentRoute = lastRoute
        } else {
            currentRoute = .home
        }
    }

    /// Go to root
    func goToRoot() {
        navigationPath = NavigationPath()
        currentRoute = .home
    }

    /// Check if onboarding is completed
    func checkOnboardingStatus() {
        isOnboardingCompleted = !persistenceService.isFirstLaunch
    }

    /// Complete onboarding
    func completeOnboarding() {
        isOnboardingCompleted = true
        navigate(to: .home)
    }
}

// MARK: - App Routes

enum AppRoute: Hashable {
    case home
    case onboarding
    case tasks
    case pets
    case reminders
    case statistics
    case settings

    // Pet-related routes
    case petDetail(petId: UUID)
    case addPet
    case editPet(petId: UUID)

    // Task-related routes
    case taskDetail(taskId: UUID)
    case addTask
    case editTask(taskId: UUID)

    // Reminder-related routes
    case reminderDetail(reminderId: UUID)
    case addReminder
    case editReminder(reminderId: UUID)

    var title: String {
        switch self {
        case .home: return "Ana Sayfa"
        case .onboarding: return "Hoş Geldiniz"
        case .tasks: return "Görevler"
        case .pets: return "Petlerim"
        case .reminders: return "Hatırlatıcılar"
        case .statistics: return "İstatistikler"
        case .settings: return "Ayarlar"
        case .petDetail: return "Pet Detayı"
        case .addPet: return "Pet Ekle"
        case .editPet: return "Pet Düzenle"
        case .taskDetail: return "Görev Detayı"
        case .addTask: return "Görev Ekle"
        case .editTask: return "Görev Düzenle"
        case .reminderDetail: return "Hatırlatıcı Detayı"
        case .addReminder: return "Hatırlatıcı Ekle"
        case .editReminder: return "Hatırlatıcı Düzenle"
        }
    }
}

// MARK: - Route Hashable Conformance

extension AppRoute {
    func hash(into hasher: inout Hasher) {
        switch self {
        case .home: hasher.combine(0)
        case .onboarding: hasher.combine(1)
        case .tasks: hasher.combine(2)
        case .pets: hasher.combine(3)
        case .reminders: hasher.combine(4)
        case .statistics: hasher.combine(5)
        case .settings: hasher.combine(6)
        case .petDetail(let petId): hasher.combine(7); hasher.combine(petId)
        case .addPet: hasher.combine(8)
        case .editPet(let petId): hasher.combine(9); hasher.combine(petId)
        case .taskDetail(let taskId): hasher.combine(10); hasher.combine(taskId)
        case .addTask: hasher.combine(11)
        case .editTask(let taskId): hasher.combine(12); hasher.combine(taskId)
        case .reminderDetail(let reminderId): hasher.combine(13); hasher.combine(reminderId)
        case .addReminder: hasher.combine(14)
        case .editReminder(let reminderId): hasher.combine(15); hasher.combine(reminderId)
        }
    }

    static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
        switch (lhs, rhs) {
        case (.home, .home): return true
        case (.onboarding, .onboarding): return true
        case (.tasks, .tasks): return true
        case (.pets, .pets): return true
        case (.reminders, .reminders): return true
        case (.statistics, .statistics): return true
        case (.settings, .settings): return true
        case (.petDetail(let lhsId), .petDetail(let rhsId)): return lhsId == rhsId
        case (.addPet, .addPet): return true
        case (.editPet(let lhsId), .editPet(let rhsId)): return lhsId == rhsId
        case (.taskDetail(let lhsId), .taskDetail(let rhsId)): return lhsId == rhsId
        case (.addTask, .addTask): return true
        case (.editTask(let lhsId), .editTask(let rhsId)): return lhsId == rhsId
        case (.reminderDetail(let lhsId), .reminderDetail(let rhsId)): return lhsId == rhsId
        case (.addReminder, .addReminder): return true
        case (.editReminder(let lhsId), .editReminder(let rhsId)): return lhsId == rhsId
        default: return false
        }
    }
}
