//
//  TaskViewModel.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for managing task-related operations
@MainActor
class TaskViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var tasks: [Task] = []
    @Published var filteredTasks: [Task] = []
    @Published var selectedTask: Task?
    @Published var isLoading = false
    @Published var error: Error?

    // MARK: - Filter Properties
    @Published var selectedCategory: TaskCategory?
    @Published var selectedPetId: UUID?
    @Published var showCompleted = false
    @Published var sortOption: TaskSortOption = .dueDate

    // MARK: - Private Properties
    private let persistenceService: PersistenceService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(persistenceService: PersistenceService = PersistenceService.shared) {
        self.persistenceService = persistenceService
        setupBindings()
        loadTasks()
    }

    // MARK: - Public Methods

    /// Load all tasks from storage
    func loadTasks() {
        isLoading = true
        error = nil

        do {
            tasks = try persistenceService.loadTasks()
            applyFilters()
        } catch {
            self.error = error
            tasks = []
            filteredTasks = []
        }

        isLoading = false
    }

    /// Add a new task
    func addTask(_ task: Task) async throws {
        isLoading = true
        defer { isLoading = false }

        var newTask = task
        newTask.updatedAt = Date()

        do {
            try await persistenceService.saveTask(newTask)
            tasks.append(newTask)
            applyFilters()
        } catch {
            self.error = error
            throw error
        }
    }

    /// Update an existing task
    func updateTask(_ task: Task) async throws {
        isLoading = true
        defer { isLoading = false }

        var updatedTask = task
        updatedTask.updatedAt = Date()

        do {
            try await persistenceService.updateTask(updatedTask)
            if let index = tasks.firstIndex(where: { $0.id == task.id }) {
                tasks[index] = updatedTask
                applyFilters()
            }
        } catch {
            self.error = error
            throw error
        }
    }

    /// Delete a task
    func deleteTask(_ task: Task) async throws {
        isLoading = true
        defer { isLoading = false }

        do {
            try await persistenceService.deleteTask(task.id)
            tasks.removeAll { $0.id == task.id }
            applyFilters()
            if selectedTask?.id == task.id {
                selectedTask = nil
            }
        } catch {
            self.error = error
            throw error
        }
    }

    /// Mark task as completed
    func markTaskCompleted(_ task: Task) async throws {
        var updatedTask = task
        updatedTask.markCompleted()
        try await updateTask(updatedTask)
    }

    /// Select a task
    func selectTask(_ task: Task?) {
        selectedTask = task
    }

    // MARK: - Filtering and Sorting
    func setCategoryFilter(_ category: TaskCategory?) {
        selectedCategory = category
    }

    func setPetFilter(_ petId: UUID?) {
        selectedPetId = petId
    }

    func toggleShowCompleted() {
        showCompleted.toggle()
    }

    func setSortOption(_ option: TaskSortOption) {
        sortOption = option
    }

    // MARK: - Computed Properties
    var todaysTasks: [Task] {
        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return dueDate >= today && dueDate < tomorrow && !task.isCompleted
        }
    }

    var overdueTasks: [Task] {
        tasks.filter { $0.isOverdue }
    }

    var upcomingTasks: [Task] {
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return dueDate >= tomorrow && !task.isCompleted && !task.isOverdue
        }
    }

    var completedTasksCount: Int {
        tasks.filter { $0.isCompleted }.count
    }

    // MARK: - Private Methods
    private func setupBindings() {
        Publishers.CombineLatest4($selectedCategory, $selectedPetId, $showCompleted, $sortOption)
            .sink { [weak self] _, _, _, _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }

    private func applyFilters() {
        var filtered = tasks

        // Category filter
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }

        // Pet filter
        if let petId = selectedPetId {
            filtered = filtered.filter { $0.petId == petId }
        }

        // Completed filter
        if !showCompleted {
            filtered = filtered.filter { !$0.isCompleted }
        }

        // Sort
        filtered = sortTasks(filtered, by: sortOption)

        filteredTasks = filtered
    }

    private func sortTasks(_ tasks: [Task], by option: TaskSortOption) -> [Task] {
        switch option {
        case .dueDate:
            return tasks.sorted { (task1, task2) -> Bool in
                let date1 = task1.dueDate ?? Date.distantFuture
                let date2 = task2.dueDate ?? Date.distantFuture
                return date1 < date2
            }
        case .priority:
            return tasks.sorted { (task1, task2) -> Bool in
                let priorityOrder: [TaskPriority] = [.urgent, .high, .medium, .low]
                let index1 = priorityOrder.firstIndex(of: task1.priority) ?? 0
                let index2 = priorityOrder.firstIndex(of: task2.priority) ?? 0
                return index1 < index2
            }
        case .category:
            return tasks.sorted { $0.category.rawValue < $1.category.rawValue }
        case .createdDate:
            return tasks.sorted { $0.createdAt > $1.createdAt }
        }
    }
}

// MARK: - Task Sort Options
enum TaskSortOption: String, CaseIterable {
    case dueDate = "Son Tarih"
    case priority = "Öncelik"
    case category = "Kategori"
    case createdDate = "Oluşturulma Tarihi"

    var displayName: String {
        rawValue
    }
}
