//
//  PersistenceService.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Service for managing data persistence using UserDefaults and JSON encoding/decoding
class PersistenceService {
    // MARK: - Singleton
    static let shared = PersistenceService()

    // MARK: - Private Properties
    private let userDefaults: UserDefaults
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder

    // MARK: - Keys
    private enum Keys {
        static let pets = "pets"
        static let tasks = "tasks"
        static let reminders = "reminders"
        static let appSettings = "appSettings"
        static let firstLaunch = "firstLaunch"
    }

    // MARK: - Initialization
    private init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults

        self.jsonEncoder = JSONEncoder()
        self.jsonEncoder.dateEncodingStrategy = .iso8601

        self.jsonDecoder = JSONDecoder()
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }

    // MARK: - Pet Methods

    /// Load all pets from storage
    func loadPets() throws -> [Pet] {
        guard let data = userDefaults.data(forKey: Keys.pets) else {
            return []
        }
        return try jsonDecoder.decode([Pet].self, from: data)
    }

    /// Save a new pet
    func savePet(_ pet: Pet) async throws {
        var pets = try loadPets()
        pets.append(pet)
        let data = try jsonEncoder.encode(pets)
        userDefaults.set(data, forKey: Keys.pets)
    }

    /// Update an existing pet
    func updatePet(_ pet: Pet) async throws {
        var pets = try loadPets()
        if let index = pets.firstIndex(where: { $0.id == pet.id }) {
            pets[index] = pet
            let data = try jsonEncoder.encode(pets)
            userDefaults.set(data, forKey: Keys.pets)
        }
    }

    /// Delete a pet by ID
    func deletePet(_ petId: UUID) async throws {
        var pets = try loadPets()
        pets.removeAll { $0.id == petId }
        let data = try jsonEncoder.encode(pets)
        userDefaults.set(data, forKey: Keys.pets)
    }

    // MARK: - Task Methods

    /// Load all tasks from storage
    func loadTasks() throws -> [Task] {
        guard let data = userDefaults.data(forKey: Keys.tasks) else {
            return []
        }
        return try jsonDecoder.decode([Task].self, from: data)
    }

    /// Save a new task
    func saveTask(_ task: Task) async throws {
        var tasks = try loadTasks()
        tasks.append(task)
        let data = try jsonEncoder.encode(tasks)
        userDefaults.set(data, forKey: Keys.tasks)
    }

    /// Update an existing task
    func updateTask(_ task: Task) async throws {
        var tasks = try loadTasks()
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index] = task
            let data = try jsonEncoder.encode(tasks)
            userDefaults.set(data, forKey: Keys.tasks)
        }
    }

    /// Delete a task by ID
    func deleteTask(_ taskId: UUID) async throws {
        var tasks = try loadTasks()
        tasks.removeAll { $0.id == taskId }
        let data = try jsonEncoder.encode(tasks)
        userDefaults.set(data, forKey: Keys.tasks)
    }

    // MARK: - Reminder Methods

    /// Load all reminders from storage
    func loadReminders() throws -> [Reminder] {
        guard let data = userDefaults.data(forKey: Keys.reminders) else {
            return []
        }
        return try jsonDecoder.decode([Reminder].self, from: data)
    }

    /// Save a new reminder
    func saveReminder(_ reminder: Reminder) async throws {
        var reminders = try loadReminders()
        reminders.append(reminder)
        let data = try jsonEncoder.encode(reminders)
        userDefaults.set(data, forKey: Keys.reminders)
    }

    /// Update an existing reminder
    func updateReminder(_ reminder: Reminder) async throws {
        var reminders = try loadReminders()
        if let index = reminders.firstIndex(where: { $0.id == reminder.id }) {
            reminders[index] = reminder
            let data = try jsonEncoder.encode(reminders)
            userDefaults.set(data, forKey: Keys.reminders)
        }
    }

    /// Delete a reminder by ID
    func deleteReminder(_ reminderId: UUID) async throws {
        var reminders = try loadReminders()
        reminders.removeAll { $0.id == reminderId }
        let data = try jsonEncoder.encode(reminders)
        userDefaults.set(data, forKey: Keys.reminders)
    }

    // MARK: - App Settings

    /// Check if this is the first launch
    var isFirstLaunch: Bool {
        !userDefaults.bool(forKey: Keys.firstLaunch)
    }

    /// Mark first launch as complete
    func markFirstLaunchComplete() {
        userDefaults.set(true, forKey: Keys.firstLaunch)
    }

    // MARK: - Utility Methods

    /// Clear all data (useful for testing or reset)
    func clearAllData() {
        userDefaults.removeObject(forKey: Keys.pets)
        userDefaults.removeObject(forKey: Keys.tasks)
        userDefaults.removeObject(forKey: Keys.reminders)
        userDefaults.removeObject(forKey: Keys.appSettings)
        userDefaults.removeObject(forKey: Keys.firstLaunch)
    }

    /// Export data as JSON string
    func exportData() throws -> String {
        let data: [String: Any] = [
            "pets": try loadPets(),
            "tasks": try loadTasks(),
            "reminders": try loadReminders(),
            "exportDate": Date()
        ]
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
        return String(data: jsonData, encoding: .utf8) ?? "{}"
    }

    /// Import data from JSON string
    func importData(from jsonString: String) throws {
        guard let jsonData = jsonString.data(using: .utf8),
              let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            throw PersistenceError.invalidDataFormat
        }

        // Import pets
        if let petsData = jsonObject["pets"] as? [[String: Any]] {
            let petsJsonData = try JSONSerialization.data(withJSONObject: petsData)
            let pets = try jsonDecoder.decode([Pet].self, from: petsJsonData)
            let encodedPets = try jsonEncoder.encode(pets)
            userDefaults.set(encodedPets, forKey: Keys.pets)
        }

        // Import tasks
        if let tasksData = jsonObject["tasks"] as? [[String: Any]] {
            let tasksJsonData = try JSONSerialization.data(withJSONObject: tasksData)
            let tasks = try jsonDecoder.decode([Task].self, from: tasksJsonData)
            let encodedTasks = try jsonEncoder.encode(tasks)
            userDefaults.set(encodedTasks, forKey: Keys.tasks)
        }

        // Import reminders
        if let remindersData = jsonObject["reminders"] as? [[String: Any]] {
            let remindersJsonData = try JSONSerialization.data(withJSONObject: remindersData)
            let reminders = try jsonDecoder.decode([Reminder].self, from: remindersJsonData)
            let encodedReminders = try jsonEncoder.encode(reminders)
            userDefaults.set(encodedReminders, forKey: Keys.reminders)
        }
    }
}

// MARK: - Persistence Errors
enum PersistenceError: Error {
    case invalidDataFormat
    case encodingFailed
    case decodingFailed

    var localizedDescription: String {
        switch self {
        case .invalidDataFormat:
            return "Geçersiz veri formatı"
        case .encodingFailed:
            return "Veri kodlanırken hata oluştu"
        case .decodingFailed:
            return "Veri çözülürken hata oluştu"
        }
    }
}
