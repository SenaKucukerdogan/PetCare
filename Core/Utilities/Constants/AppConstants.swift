//
//  AppConstants.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Application-wide constants
struct AppConstants {
    // MARK: - App Information
    static let appName = "PetCare"
    static let appVersion = "1.0.0"
    static let appBuild = "1"
    static let minimumOSVersion = "16.0"

    // MARK: - API Configuration (for future use)
    static let apiBaseURL = "https://api.petcare.com"
    static let apiTimeout: TimeInterval = 30.0

    // MARK: - Storage Keys
    struct StorageKeys {
        static let pets = "pets"
        static let tasks = "tasks"
        static let reminders = "reminders"
        static let userPreferences = "userPreferences"
        static let appSettings = "appSettings"
        static let firstLaunch = "firstLaunch"
        static let lastSyncDate = "lastSyncDate"
        static let userId = "userId"
    }

    // MARK: - Notification Identifiers
    struct NotificationIdentifiers {
        static let dailySummary = "daily-summary"
        static let weeklyReport = "weekly-report"
        static let taskReminder = "task-reminder"
        static let vaccineReminder = "vaccine-reminder"
        static let medicationReminder = "medication-reminder"
    }

    // MARK: - Limits and Constraints
    struct Limits {
        static let maxPetNameLength = 50
        static let maxTaskTitleLength = 100
        static let maxTaskDescriptionLength = 500
        static let maxReminderTitleLength = 100
        static let maxReminderMessageLength = 250
        static let maxVaccineNameLength = 100
        static let maxMedicationNameLength = 100
        static let maxMedicationDosageLength = 50
        static let maxInstructionsLength = 500
        static let maxImageSizeInMB = 5.0
        static let maxImageDimension = 1024
    }

    // MARK: - Time Intervals
    struct TimeIntervals {
        static let dailySummaryHour = 20
        static let dailySummaryMinute = 0
        static let weeklyReportWeekday = 1 // Sunday
        static let weeklyReportHour = 9
        static let defaultReminderAdvanceTime: TimeInterval = 3600 // 1 hour
        static let syncInterval: TimeInterval = 3600 // 1 hour
    }

    // MARK: - Default Values
    struct Defaults {
        static let defaultPetType = PetType.dog
        static let defaultTaskPriority = TaskPriority.medium
        static let defaultTaskCategory = TaskCategory.other
        static let defaultReminderEnabled = true
        static let defaultNotificationSound = "default"
        static let defaultTheme = AppTheme.system
        static let defaultLanguage = "tr"
    }

    // MARK: - UI Constants
    struct UI {
        static let cornerRadius: CGFloat = 12
        static let borderWidth: CGFloat = 1
        static let shadowRadius: CGFloat = 4
        static let animationDuration: Double = 0.3
        static let springResponse: Double = 0.4
        static let springDamping: Double = 0.8
        static let cardPadding: CGFloat = 16
        static let screenPadding: CGFloat = 20
    }

    // MARK: - Analytics Events
    struct AnalyticsEvents {
        static let appLaunch = "app_launch"
        static let petAdded = "pet_added"
        static let petEdited = "pet_edited"
        static let petDeleted = "pet_deleted"
        static let taskAdded = "task_added"
        static let taskCompleted = "task_completed"
        static let taskDeleted = "task_deleted"
        static let reminderAdded = "reminder_added"
        static let reminderTriggered = "reminder_triggered"
        static let vaccineAdded = "vaccine_added"
        static let medicationAdded = "medication_added"
        static let settingsChanged = "settings_changed"
    }

    // MARK: - Error Messages
    struct ErrorMessages {
        static let networkError = "İnternet bağlantınızı kontrol edin"
        static let saveError = "Veri kaydedilirken hata oluştu"
        static let loadError = "Veri yüklenirken hata oluştu"
        static let deleteError = "Veri silinirken hata oluştu"
        static let validationError = "Girilen bilgiler geçersiz"
        static let permissionError = "İzin gerekli"
        static let unknownError = "Bilinmeyen bir hata oluştu"
    }

    // MARK: - Success Messages
    struct SuccessMessages {
        static let saveSuccess = "Başarıyla kaydedildi"
        static let deleteSuccess = "Başarıyla silindi"
        static let updateSuccess = "Başarıyla güncellendi"
        static let syncSuccess = "Senkronizasyon tamamlandı"
    }

    // MARK: - Date Formats
    struct DateFormats {
        static let shortDate = "dd.MM.yyyy"
        static let mediumDate = "dd MMM yyyy"
        static let longDate = "dd MMMM yyyy"
        static let timeOnly = "HH:mm"
        static let dateTime = "dd.MM.yyyy HH:mm"
        static let iso8601 = "yyyy-MM-dd'T'HH:mm:ssZ"
    }

    // MARK: - File Extensions
    struct FileExtensions {
        static let json = "json"
        static let image = "jpg"
        static let backup = "petcare"
    }

    // MARK: - URLs
    struct URLs {
        static let privacyPolicy = "https://petcare.com/privacy"
        static let termsOfService = "https://petcare.com/terms"
        static let support = "https://petcare.com/support"
        static let appStore = "https://apps.apple.com/app/petcare"
    }
}

// MARK: - Supporting Types

enum AppTheme: String, Codable {
    case light = "Açık"
    case dark = "Koyu"
    case system = "Sistem"

    var displayName: String {
        rawValue
    }
}

enum AppLanguage: String, Codable {
    case turkish = "tr"
    case english = "en"

    var displayName: String {
        switch self {
        case .turkish: return "Türkçe"
        case .english: return "English"
        }
    }

    var locale: String {
        rawValue
    }
}

enum NotificationSound: String, Codable, CaseIterable {
    case `default` = "Varsayılan"
    case bell = "Çan"
    case chime = "Çınlama"
    case none = "Sessiz"

    var filename: String? {
        switch self {
        case .default: return nil
        case .bell: return "bell.wav"
        case .chime: return "chime.wav"
        case .none: return nil
        }
    }
}
