//
//  ReminderViewModel.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation
import SwiftUI
import Combine
import UserNotifications

/// ViewModel for managing reminder notifications
@MainActor
class ReminderViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var reminders: [Reminder] = []
    @Published var selectedReminder: Reminder?
    @Published var isLoading = false
    @Published var error: Error?

    // MARK: - Notification Properties
    @Published var notificationPermissionGranted = false
    @Published var pendingNotificationsCount = 0

    // MARK: - Private Properties
    private let persistenceService: PersistenceService
    private let notificationService: NotificationService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(persistenceService: PersistenceService = PersistenceService.shared,
         notificationService: NotificationService = NotificationService.shared) {
        self.persistenceService = persistenceService
        self.notificationService = notificationService
        setupBindings()
        checkNotificationPermissions()
        loadReminders()
    }

    // MARK: - Public Methods

    /// Load all reminders from storage
    func loadReminders() {
        isLoading = true
        error = nil

        do {
            reminders = try persistenceService.loadReminders()
            updatePendingNotificationsCount()
        } catch {
            self.error = error
            reminders = []
        }

        isLoading = false
    }

    /// Add a new reminder
    func addReminder(_ reminder: Reminder) async throws {
        isLoading = true
        defer { isLoading = false }

        var newReminder = reminder
        newReminder.updatedAt = Date()
        newReminder.notificationId = UUID().uuidString

        do {
            try await persistenceService.saveReminder(newReminder)

            if newReminder.isEnabled {
                try await notificationService.scheduleReminder(newReminder)
            }

            reminders.append(newReminder)
            updatePendingNotificationsCount()
        } catch {
            self.error = error
            throw error
        }
    }

    /// Update an existing reminder
    func updateReminder(_ reminder: Reminder) async throws {
        isLoading = true
        defer { isLoading = false }

        var updatedReminder = reminder
        updatedReminder.updatedAt = Date()

        do {
            try await persistenceService.updateReminder(updatedReminder)

            // Cancel existing notification if it exists
            if let notificationId = reminder.notificationId {
                await notificationService.cancelReminder(notificationId: notificationId)
            }

            // Schedule new notification if enabled
            if updatedReminder.isEnabled {
                try await notificationService.scheduleReminder(updatedReminder)
            }

            if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
                reminders[index] = updatedReminder
                updatePendingNotificationsCount()
            }
        } catch {
            self.error = error
            throw error
        }
    }

    /// Delete a reminder
    func deleteReminder(_ reminder: Reminder) async throws {
        isLoading = true
        defer { isLoading = false }

        do {
            // Cancel notification if it exists
            if let notificationId = reminder.notificationId {
                await notificationService.cancelReminder(notificationId: notificationId)
            }

            try await persistenceService.deleteReminder(reminder.id)
            reminders.removeAll { $0.id == reminder.id }
            updatePendingNotificationsCount()

            if selectedReminder?.id == reminder.id {
                selectedReminder = nil
            }
        } catch {
            self.error = error
            throw error
        }
    }

    /// Toggle reminder enabled state
    func toggleReminder(_ reminder: Reminder) async throws {
        var updatedReminder = reminder
        updatedReminder.isEnabled.toggle()
        try await updateReminder(updatedReminder)
    }

    /// Select a reminder
    func selectReminder(_ reminder: Reminder?) {
        selectedReminder = reminder
    }

    /// Request notification permissions
    func requestNotificationPermissions() async {
        do {
            let granted = try await notificationService.requestPermissions()
            notificationPermissionGranted = granted
        } catch {
            self.error = error
        }
    }

    // MARK: - Computed Properties
    var enabledReminders: [Reminder] {
        reminders.filter { $0.isEnabled }
    }

    var disabledReminders: [Reminder] {
        reminders.filter { !$0.isEnabled }
    }

    var todaysReminders: [Reminder] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        return reminders.filter { reminder in
            reminder.isEnabled &&
            reminder.scheduledDate >= today &&
            reminder.scheduledDate < tomorrow
        }
    }

    var upcomingReminders: [Reminder] {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return reminders.filter { reminder in
            reminder.isEnabled && reminder.scheduledDate >= tomorrow
        }.sorted { $0.scheduledDate < $1.scheduledDate }
    }

    // MARK: - Private Methods
    private func setupBindings() {
        $reminders
            .sink { [weak self] _ in
                self?.updatePendingNotificationsCount()
            }
            .store(in: &cancellables)
    }

    private func checkNotificationPermissions() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationPermissionGranted = (settings.authorizationStatus == .authorized)
            }
        }
    }

    private func updatePendingNotificationsCount() {
        pendingNotificationsCount = enabledReminders.count
    }
}

// MARK: - Reminder Statistics
extension ReminderViewModel {
    var totalReminders: Int {
        reminders.count
    }

    var activeRemindersCount: Int {
        enabledReminders.count
    }

    var remindersThisWeek: Int {
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!

        return reminders.filter { reminder in
            reminder.isEnabled &&
            reminder.scheduledDate >= startOfWeek &&
            reminder.scheduledDate <= endOfWeek
        }.count
    }
}
