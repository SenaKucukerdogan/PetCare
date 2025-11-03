//
//  StatisticsViewModel.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation
import SwiftUI
import Combine

/// ViewModel for managing statistics and analytics
@MainActor
class StatisticsViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var weeklyStats: WeeklyStatistics = .empty
    @Published var monthlyStats: MonthlyStatistics = .empty
    @Published var petStats: [PetStatistics] = []
    @Published var categoryStats: [TaskCategory: Int] = [:]
    @Published var isLoading = false
    @Published var error: Error?

    // MARK: - Private Properties
    private let analyticsService: AnalyticsService
    private let petViewModel: PetViewModel
    private let taskViewModel: TaskViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Initialization
    init(analyticsService: AnalyticsService = AnalyticsService.shared,
         petViewModel: PetViewModel = PetViewModel(),
         taskViewModel: TaskViewModel = TaskViewModel()) {
        self.analyticsService = analyticsService
        self.petViewModel = petViewModel
        self.taskViewModel = taskViewModel
        setupBindings()
        loadStatistics()
    }

    // MARK: - Public Methods

    /// Load all statistics
    func loadStatistics() {
        isLoading = true
        error = nil

        Task {
            do {
                async let weekly = analyticsService.getWeeklyStatistics()
                async let monthly = analyticsService.getMonthlyStatistics()
                async let petStats = analyticsService.getPetStatistics()
                async let categoryStats = analyticsService.getTaskCategoryStatistics()

                let (weeklyResult, monthlyResult, petStatsResult, categoryStatsResult) = try await (weekly, monthly, petStats, categoryStats)

                self.weeklyStats = weeklyResult
                self.monthlyStats = monthlyResult
                self.petStats = petStatsResult
                self.categoryStats = categoryStatsResult
            } catch {
                self.error = error
            }

            isLoading = false
        }
    }

    /// Refresh statistics
    func refreshStatistics() {
        loadStatistics()
    }

    // MARK: - Computed Properties

    /// Overall completion rate
    var overallCompletionRate: Double {
        let totalTasks = Double(weeklyStats.totalTasks + monthlyStats.totalTasks)
        let completedTasks = Double(weeklyStats.completedTasks + monthlyStats.completedTasks)
        return totalTasks > 0 ? (completedTasks / totalTasks) * 100 : 0
    }

    /// Most active pet
    var mostActivePet: PetStatistics? {
        petStats.max { $0.tasksCompleted < $1.tasksCompleted }
    }

    /// Most common task category
    var mostCommonCategory: (TaskCategory, Int)? {
        categoryStats.max { $0.value < $1.value }.map { ($0.key, $0.value) }
    }

    /// Weekly progress trend
    var weeklyProgress: Double {
        let total = Double(weeklyStats.totalTasks)
        let completed = Double(weeklyStats.completedTasks)
        return total > 0 ? (completed / total) * 100 : 0
    }

    /// Monthly progress trend
    var monthlyProgress: Double {
        let total = Double(monthlyStats.totalTasks)
        let completed = Double(monthlyStats.completedTasks)
        return total > 0 ? (completed / total) * 100 : 0
    }

    /// Average tasks per pet
    var averageTasksPerPet: Double {
        let totalPets = Double(petStats.count)
        let totalTasks = Double(petStats.reduce(0) { $0 + $1.tasksCompleted })
        return totalPets > 0 ? totalTasks / totalPets : 0
    }

    // MARK: - Statistics Data Structures
    struct WeeklyStatistics {
        let totalTasks: Int
        let completedTasks: Int
        let overdueTasks: Int
        let activeReminders: Int
        let period: DateInterval

        static var empty: WeeklyStatistics {
            let calendar = Calendar.current
            let now = Date()
            let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
            let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!
            return WeeklyStatistics(
                totalTasks: 0,
                completedTasks: 0,
                overdueTasks: 0,
                activeReminders: 0,
                period: DateInterval(start: weekStart, end: weekEnd)
            )
        }
    }

    struct MonthlyStatistics {
        let totalTasks: Int
        let completedTasks: Int
        let overdueTasks: Int
        let activeReminders: Int
        let period: DateInterval

        static var empty: MonthlyStatistics {
            let calendar = Calendar.current
            let now = Date()
            let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
            let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)!
            return MonthlyStatistics(
                totalTasks: 0,
                completedTasks: 0,
                overdueTasks: 0,
                activeReminders: 0,
                period: DateInterval(start: monthStart, end: monthEnd)
            )
        }
    }

    struct PetStatistics: Identifiable {
        let id = UUID()
        let petId: UUID
        let petName: String
        let tasksCompleted: Int
        let tasksPending: Int
        let averageCompletionTime: TimeInterval?
        let favoriteCategory: TaskCategory?

        var completionRate: Double {
            let total = Double(tasksCompleted + tasksPending)
            return total > 0 ? Double(tasksCompleted) / total : 0
        }
    }

    // MARK: - Private Methods
    private func setupBindings() {
        // Refresh statistics when pet or task data changes
        petViewModel.$pets
            .combineLatest(taskViewModel.$tasks)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .sink { [weak self] _, _ in
                self?.loadStatistics()
            }
            .store(in: &cancellables)
    }
}
