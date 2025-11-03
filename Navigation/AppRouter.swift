//
//  AppRouter.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

/// Router for managing app navigation and view routing
struct AppRouter: View {
    @StateObject private var coordinator = NavigationCoordinator()

    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            ZStack {
                if coordinator.isOnboardingCompleted {
                    MainTabView()
                } else {
                    OnboardingView()
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                destinationView(for: route)
            }
        }
        .environmentObject(coordinator)
    }

    @ViewBuilder
    private func destinationView(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView()
        case .onboarding:
            OnboardingView()
        case .tasks:
            Text("Tasks View - Coming Soon")
        case .pets:
            Text("Pets View - Coming Soon")
        case .reminders:
            Text("Reminders View - Coming Soon")
        case .statistics:
            Text("Statistics View - Coming Soon")
        case .settings:
            Text("Settings View - Coming Soon")
        case .petDetail(let petId):
            Text("Pet Detail View for \(petId) - Coming Soon")
        case .addPet:
            Text("Add Pet View - Coming Soon")
        case .editPet(let petId):
            Text("Edit Pet View for \(petId) - Coming Soon")
        case .taskDetail(let taskId):
            Text("Task Detail View for \(taskId) - Coming Soon")
        case .addTask:
            Text("Add Task View - Coming Soon")
        case .editTask(let taskId):
            Text("Edit Task View for \(taskId) - Coming Soon")
        case .reminderDetail(let reminderId):
            Text("Reminder Detail View for \(reminderId) - Coming Soon")
        case .addReminder:
            Text("Add Reminder View - Coming Soon")
        case .editReminder(let reminderId):
            Text("Edit Reminder View for \(reminderId) - Coming Soon")
        }
    }
}

// MARK: - Preview

struct AppRouter_Previews: PreviewProvider {
    static var previews: some View {
        AppRouter()
            .previewDisplayName("App Router")
    }
}
