//
//  NotificationService.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation
import UserNotifications
import UIKit

/// Service for managing local notifications
class NotificationService: NSObject {
    // MARK: - Singleton
    static let shared = NotificationService()

    // MARK: - Private Properties
    private let notificationCenter = UNUserNotificationCenter.current()
    private let persistenceService = PersistenceService.shared

    // MARK: - Initialization
    private override init() {
        super.init()
        notificationCenter.delegate = self
    }

    // MARK: - Public Methods

    /// Request notification permissions
    func requestPermissions() async throws -> Bool {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        let granted = try await notificationCenter.requestAuthorization(options: options)
        return granted
    }

    /// Check current notification permissions
    func checkPermissions() async -> Bool {
        let settings = await notificationCenter.notificationSettings()
        return settings.authorizationStatus == .authorized
    }

    /// Schedule a reminder notification
    func scheduleReminder(_ reminder: Reminder) async throws {
        guard reminder.isEnabled else { return }

        let content = UNMutableNotificationContent()
        content.title = reminder.title

        if let message = reminder.message {
            content.body = message
        } else {
            content.body = "PetCare hatırlatıcısı"
        }

        content.sound = .default
        content.badge = 1

        // Add pet information if available
        if let petId = reminder.petId {
            do {
                let pets = try persistenceService.loadPets()
                if let pet = pets.first(where: { $0.id == petId }) {
                    content.subtitle = pet.name
                    content.userInfo = ["petId": petId.uuidString, "reminderId": reminder.id.uuidString]
                }
            } catch {
                // Continue without pet info if loading fails
            }
        }

        let trigger = createTrigger(for: reminder)
        let request = UNNotificationRequest(
            identifier: reminder.notificationId ?? reminder.id.uuidString,
            content: content,
            trigger: trigger
        )

        try await notificationCenter.add(request)
    }

    /// Cancel a specific reminder notification
    func cancelReminder(notificationId: String) async {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [notificationId])
        notificationCenter.removeDeliveredNotifications(withIdentifiers: [notificationId])
    }

    /// Cancel all notifications
    func cancelAllNotifications() {
        notificationCenter.removeAllPendingNotificationRequests()
        notificationCenter.removeAllDeliveredNotifications()
    }

    /// Get pending notifications count
    func getPendingNotificationsCount() async -> Int {
        let requests = await notificationCenter.pendingNotificationRequests()
        return requests.count
    }

    /// Schedule daily summary notification
    func scheduleDailySummary(at hour: Int = 20, minute: Int = 0) async throws {
        let content = UNMutableNotificationContent()
        content.title = "Günlük Özet"
        content.body = "Bugün tamamlanan görevleri kontrol edin"
        content.sound = .default

        let trigger = createDailyTrigger(hour: hour, minute: minute)
        let request = UNNotificationRequest(
            identifier: "daily-summary",
            content: content,
            trigger: trigger
        )

        try await notificationCenter.add(request)
    }

    /// Schedule weekly report notification
    func scheduleWeeklyReport(weekday: Int = 1, hour: Int = 9) async throws { // Sunday = 1
        let content = UNMutableNotificationContent()
        content.title = "Haftalık Rapor"
        content.body = "Bu haftanın istatistiklerini inceleyin"
        content.sound = .default

        let trigger = createWeeklyTrigger(weekday: weekday, hour: hour)
        let request = UNNotificationRequest(
            identifier: "weekly-report",
            content: content,
            trigger: trigger
        )

        try await notificationCenter.add(request)
    }

    // MARK: - Private Methods

    private func createTrigger(for reminder: Reminder) -> UNNotificationTrigger {
        if reminder.isRepeating, let interval = reminder.repeatInterval {
            return UNTimeIntervalNotificationTrigger(
                timeInterval: interval,
                repeats: true
            )
        } else {
            let timeInterval = max(1, reminder.scheduledDate.timeIntervalSince(Date()))
            return UNTimeIntervalNotificationTrigger(
                timeInterval: timeInterval,
                repeats: false
            )
        }
    }

    private func createDailyTrigger(hour: Int, minute: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.hour = hour
        dateComponents.minute = minute
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }

    private func createWeeklyTrigger(weekday: Int, hour: Int) -> UNCalendarNotificationTrigger {
        var dateComponents = DateComponents()
        dateComponents.weekday = weekday
        dateComponents.hour = hour
        return UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show notification even when app is in foreground
        completionHandler([.banner, .sound, .badge])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        // Handle notification tap
        let userInfo = response.notification.request.content.userInfo

        if let petIdString = userInfo["petId"] as? String,
           let reminderIdString = userInfo["reminderId"] as? String {
            // Handle pet-specific reminder tap
            print("Tapped reminder for pet: \(petIdString), reminder: \(reminderIdString)")
        }

        completionHandler()
    }
}
