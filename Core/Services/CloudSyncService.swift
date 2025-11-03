//
//  CloudSyncService.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation
import CloudKit

/// Service for managing iCloud synchronization (optional feature)
class CloudSyncService {
    // MARK: - Singleton
    static let shared = CloudSyncService()

    // MARK: - Private Properties
    private let container: CKContainer
    private let privateDatabase: CKDatabase
    private let persistenceService = PersistenceService.shared

    // MARK: - Published Properties
    @Published var isSyncEnabled = false
    @Published var isSyncing = false
    @Published var lastSyncDate: Date?

    // MARK: - Initialization
    private init() {
        container = CKContainer.default()
        privateDatabase = container.privateCloudDatabase
        checkiCloudAvailability()
    }

    // MARK: - Public Methods

    /// Check if iCloud is available and enabled
    func checkiCloudAvailability() {
        container.accountStatus { [weak self] status, error in
            DispatchQueue.main.async {
                self?.isSyncEnabled = (status == .available)
                if let error = error {
                    print("iCloud account status error: \(error.localizedDescription)")
                }
            }
        }
    }

    /// Enable iCloud sync
    func enableSync() async throws {
        guard isSyncEnabled else {
            throw CloudSyncError.iCloudUnavailable
        }

        // Initial sync from iCloud
        try await syncFromCloud()
    }

    /// Disable iCloud sync
    func disableSync() {
        isSyncEnabled = false
        lastSyncDate = nil
    }

    /// Sync data to iCloud
    func syncToCloud() async throws {
        guard isSyncEnabled else { return }

        isSyncing = true
        defer { isSyncing = false }

        do {
            // Sync pets
            let pets = try persistenceService.loadPets()
            try await syncPetsToCloud(pets)

            // Sync tasks
            let tasks = try persistenceService.loadTasks()
            try await syncTasksToCloud(tasks)

            // Sync reminders
            let reminders = try persistenceService.loadReminders()
            try await syncRemindersToCloud(reminders)

            lastSyncDate = Date()
        } catch {
            throw error
        }
    }

    /// Sync data from iCloud
    func syncFromCloud() async throws {
        guard isSyncEnabled else { return }

        isSyncing = true
        defer { isSyncing = false }

        do {
            // Sync pets from cloud
            let cloudPets = try await fetchPetsFromCloud()
            for pet in cloudPets {
                try await persistenceService.savePet(pet)
            }

            // Sync tasks from cloud
            let cloudTasks = try await fetchTasksFromCloud()
            for task in cloudTasks {
                try await persistenceService.saveTask(task)
            }

            // Sync reminders from cloud
            let cloudReminders = try await fetchRemindersFromCloud()
            for reminder in cloudReminders {
                try await persistenceService.saveReminder(reminder)
            }

            lastSyncDate = Date()
        } catch {
            throw error
        }
    }

    // MARK: - Private Sync Methods

    private func syncPetsToCloud(_ pets: [Pet]) async throws {
        let records = pets.map { pet -> CKRecord in
            let record = CKRecord(recordType: "Pet", recordID: CKRecord.ID(recordName: pet.id.uuidString))
            record["name"] = pet.name
            record["type"] = pet.type.rawValue
            record["breed"] = pet.breed
            record["birthDate"] = pet.birthDate
            record["weight"] = pet.weight
            record["isActive"] = pet.isActive
            record["createdAt"] = pet.createdAt
            record["updatedAt"] = pet.updatedAt
            return record
        }

        try await saveRecordsToCloud(records)
    }

    private func syncTasksToCloud(_ tasks: [Task]) async throws {
        let records = tasks.map { task -> CKRecord in
            let record = CKRecord(recordType: "Task", recordID: CKRecord.ID(recordName: task.id.uuidString))
            record["title"] = task.title
            record["description"] = task.description
            record["category"] = task.category.rawValue
            record["priority"] = task.priority.rawValue
            record["petId"] = task.petId?.uuidString
            record["dueDate"] = task.dueDate
            record["isCompleted"] = task.isCompleted
            record["isRecurring"] = task.isRecurring
            record["createdAt"] = task.createdAt
            record["updatedAt"] = task.updatedAt
            return record
        }

        try await saveRecordsToCloud(records)
    }

    private func syncRemindersToCloud(_ reminders: [Reminder]) async throws {
        let records = reminders.map { reminder -> CKRecord in
            let record = CKRecord(recordType: "Reminder", recordID: CKRecord.ID(recordName: reminder.id.uuidString))
            record["title"] = reminder.title
            record["message"] = reminder.message
            record["petId"] = reminder.petId?.uuidString
            record["scheduledDate"] = reminder.scheduledDate
            record["isRepeating"] = reminder.isRepeating
            record["repeatInterval"] = reminder.repeatInterval
            record["isEnabled"] = reminder.isEnabled
            record["createdAt"] = reminder.createdAt
            record["updatedAt"] = reminder.updatedAt
            return record
        }

        try await saveRecordsToCloud(records)
    }

    private func fetchPetsFromCloud() async throws -> [Pet] {
        let query = CKQuery(recordType: "Pet", predicate: NSPredicate(value: true))
        let results = try await privateDatabase.records(matching: query)

        return try results.matchResults.compactMap { _, result in
            switch result {
            case .success(let record):
                return try Pet.fromCloudKit(record)
            case .failure:
                return nil
            }
        }
    }

    private func fetchTasksFromCloud() async throws -> [Task] {
        let query = CKQuery(recordType: "Task", predicate: NSPredicate(value: true))
        let results = try await privateDatabase.records(matching: query)

        return try results.matchResults.compactMap { _, result in
            switch result {
            case .success(let record):
                return try Task.fromCloudKit(record)
            case .failure:
                return nil
            }
        }
    }

    private func fetchRemindersFromCloud() async throws -> [Reminder] {
        let query = CKQuery(recordType: "Reminder", predicate: NSPredicate(value: true))
        let results = try await privateDatabase.records(matching: query)

        return try results.matchResults.compactMap { _, result in
            switch result {
            case .success(let record):
                return try Reminder.fromCloudKit(record)
            case .failure:
                return nil
            }
        }
    }

    private func saveRecordsToCloud(_ records: [CKRecord]) async throws {
        try await privateDatabase.save(records)
    }
}

// MARK: - CloudKit Extensions
extension Pet {
    static func fromCloudKit(_ record: CKRecord) throws -> Pet {
        guard let name = record["name"] as? String,
              let typeString = record["type"] as? String,
              let type = PetType(rawValue: typeString),
              let createdAt = record["createdAt"] as? Date,
              let updatedAt = record["updatedAt"] as? Date else {
            throw CloudSyncError.invalidRecord
        }

        return Pet(
            id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
            name: name,
            type: type,
            breed: record["breed"] as? String,
            birthDate: record["birthDate"] as? Date,
            weight: record["weight"] as? Double,
            imageData: nil, // Images not synced in this version
            isActive: record["isActive"] as? Bool ?? true
        )
    }
}

extension Task {
    static func fromCloudKit(_ record: CKRecord) throws -> Task {
        guard let title = record["title"] as? String,
              let categoryString = record["category"] as? String,
              let category = TaskCategory(rawValue: categoryString),
              let priorityString = record["priority"] as? String,
              let priority = TaskPriority(rawValue: priorityString),
              let createdAt = record["createdAt"] as? Date,
              let updatedAt = record["updatedAt"] as? Date else {
            throw CloudSyncError.invalidRecord
        }

        return Task(
            id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
            title: title,
            description: record["description"] as? String,
            category: category,
            priority: priority,
            petId: (record["petId"] as? String).flatMap { UUID(uuidString: $0) },
            dueDate: record["dueDate"] as? Date,
            isRecurring: record["isRecurring"] as? Bool ?? false,
            recurrenceType: nil, // Simplified for this version
            recurrenceInterval: nil
        )
    }
}

extension Reminder {
    static func fromCloudKit(_ record: CKRecord) throws -> Reminder {
        guard let title = record["title"] as? String,
              let scheduledDate = record["scheduledDate"] as? Date,
              let createdAt = record["createdAt"] as? Date,
              let updatedAt = record["updatedAt"] as? Date else {
            throw CloudSyncError.invalidRecord
        }

        return Reminder(
            id: UUID(uuidString: record.recordID.recordName) ?? UUID(),
            title: title,
            message: record["message"] as? String,
            petId: (record["petId"] as? String).flatMap { UUID(uuidString: $0) },
            scheduledDate: scheduledDate,
            isRepeating: record["isRepeating"] as? Bool ?? false,
            repeatInterval: record["repeatInterval"] as? TimeInterval,
            isEnabled: record["isEnabled"] as? Bool ?? true
        )
    }
}

// MARK: - Cloud Sync Errors
enum CloudSyncError: Error {
    case iCloudUnavailable
    case invalidRecord
    case syncFailed

    var localizedDescription: String {
        switch self {
        case .iCloudUnavailable:
            return "iCloud kullanılamıyor"
        case .invalidRecord:
            return "Geçersiz kayıt formatı"
        case .syncFailed:
            return "Senkronizasyon başarısız"
        }
    }
}
