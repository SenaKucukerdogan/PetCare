//
//  HomeViewModel.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for home/dashboard screen
@MainActor
class HomeViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var todaysTasks: [Task] = []
    @Published var upcomingTasks: [Task] = []
    @Published var activePets: [Pet] = []
    @Published var todaysReminders: [Reminder] = []
    @Published var isLoading = false
    @Published var error: Error?

    // MARK: - Private Properties
    private let petViewModel = PetViewModel()
    private let taskViewModel = TaskViewModel()
    private let reminderViewModel = ReminderViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init() {
        setupBindings()
        loadDashboardData()
    }

    // MARK: - Public Methods

    /// Load dashboard data
    func loadDashboardData() {
        isLoading = true
        error = nil

        DispatchQueue.main.async {
            // Load active pets
            self.activePets = self.petViewModel.activePets

            // Load today's tasks
            self.todaysTasks = self.taskViewModel.todaysTasks

            // Load upcoming tasks (next 7 days)
            self.upcomingTasks = Array(self.taskViewModel.upcomingTasks.prefix(5))

            // Load today's reminders
            self.todaysReminders = self.reminderViewModel.todaysReminders

            self.isLoading = false
        }
    }

    /// Refresh dashboard data
    func refreshData() {
        loadDashboardData()
    }

    // MARK: - Computed Properties

    var todaysCompletedTasksCount: Int {
        todaysTasks.filter { $0.isCompleted }.count
    }

    var todaysPendingTasksCount: Int {
        todaysTasks.filter { !$0.isCompleted }.count
    }

    var overdueTasksCount: Int {
        todaysTasks.filter { $0.isOverdue }.count
    }

    var totalActivePetsCount: Int {
        activePets.count
    }

    var todaysActiveRemindersCount: Int {
        todaysReminders.filter { $0.isEnabled }.count
    }

    // MARK: - Private Methods
    private func setupBindings() {
        // Refresh when underlying data changes
        petViewModel.$pets
            .combineLatest(taskViewModel.$tasks, reminderViewModel.$reminders)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _, _ in
                self?.loadDashboardData()
            }
            .store(in: &cancellables)
    }
}
