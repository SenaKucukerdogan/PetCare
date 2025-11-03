//
//  AnalyticsService.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation

/// Service for calculating statistics and analytics
class AnalyticsService {
    // MARK: - Singleton
    static let shared = AnalyticsService()

    // MARK: - Private Properties
    private let persistenceService = PersistenceService.shared

    // MARK: - Initialization
    private init() {}

    // MARK: - Public Methods

    /// Get weekly statistics
    func getWeeklyStatistics() async throws -> StatisticsViewModel.WeeklyStatistics {
        let tasks = try persistenceService.loadTasks()
        let reminders = try persistenceService.loadReminders()

        let calendar = Calendar.current
        let now = Date()
        let weekStart = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
        let weekEnd = calendar.date(byAdding: .day, value: 6, to: weekStart)!

        let weekInterval = DateInterval(start: weekStart, end: weekEnd)

        // Filter tasks for this week
        let weeklyTasks = tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return weekInterval.contains(dueDate)
        }

        let completedTasks = weeklyTasks.filter { $0.isCompleted }.count
        let overdueTasks = weeklyTasks.filter { $0.isOverdue }.count
        let activeReminders = reminders.filter { $0.isEnabled }.count

        return StatisticsViewModel.WeeklyStatistics(
            totalTasks: weeklyTasks.count,
            completedTasks: completedTasks,
            overdueTasks: overdueTasks,
            activeReminders: activeReminders,
            period: weekInterval
        )
    }

    /// Get monthly statistics
    func getMonthlyStatistics() async throws -> StatisticsViewModel.MonthlyStatistics {
        let tasks = try persistenceService.loadTasks()
        let reminders = try persistenceService.loadReminders()

        let calendar = Calendar.current
        let now = Date()
        let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: now))!
        let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)!

        let monthInterval = DateInterval(start: monthStart, end: monthEnd)

        // Filter tasks for this month
        let monthlyTasks = tasks.filter { task in
            guard let dueDate = task.dueDate else { return false }
            return monthInterval.contains(dueDate)
        }

        let completedTasks = monthlyTasks.filter { $0.isCompleted }.count
        let overdueTasks = monthlyTasks.filter { $0.isOverdue }.count
        let activeReminders = reminders.filter { $0.isEnabled }.count

        return StatisticsViewModel.MonthlyStatistics(
            totalTasks: monthlyTasks.count,
            completedTasks: completedTasks,
            overdueTasks: overdueTasks,
            activeReminders: activeReminders,
            period: monthInterval
        )
    }

    /// Get statistics for each pet
    func getPetStatistics() async throws -> [StatisticsViewModel.PetStatistics] {
        let pets = try persistenceService.loadPets()
        let tasks = try persistenceService.loadTasks()

        return pets.map { pet in
            let petTasks = tasks.filter { $0.petId == pet.id }
            let completedTasks = petTasks.filter { $0.isCompleted }
            let pendingTasks = petTasks.filter { !$0.isCompleted }

            // Calculate average completion time
            let completionTimes = completedTasks.compactMap { task -> TimeInterval? in
                guard let completedAt = task.completedAt else { return nil }
                let createdAt = task.createdAt
                return completedAt.timeIntervalSince(createdAt)
            }

            let averageCompletionTime = completionTimes.isEmpty ? nil : completionTimes.reduce(0, +) / Double(completionTimes.count)

            // Find favorite category
            let categoryCounts = Dictionary(grouping: petTasks, by: { $0.category })
                .mapValues { $0.count }
            let favoriteCategory = categoryCounts.max { $0.value < $1.value }?.key

            return StatisticsViewModel.PetStatistics(
                petId: pet.id,
                petName: pet.name,
                tasksCompleted: completedTasks.count,
                tasksPending: pendingTasks.count,
                averageCompletionTime: averageCompletionTime,
                favoriteCategory: favoriteCategory
            )
        }
    }

    /// Get task category statistics
    func getTaskCategoryStatistics() async throws -> [TaskCategory: Int] {
        let tasks = try persistenceService.loadTasks()
        return Dictionary(grouping: tasks, by: { $0.category })
            .mapValues { $0.count }
    }

    /// Get completion rate over time
    func getCompletionRateOverTime(days: Int = 30) async throws -> [(date: Date, rate: Double)] {
        let tasks = try persistenceService.loadTasks()
        let calendar = Calendar.current
        let now = Date()

        var completionRates: [(date: Date, rate: Double)] = []

        for dayOffset in (0..<days).reversed() {
            let date = calendar.date(byAdding: .day, value: -dayOffset, to: now)!
            let dayStart = calendar.startOfDay(for: date)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!

            let dayInterval = DateInterval(start: dayStart, end: dayEnd)
            let dayTasks = tasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dayInterval.contains(dueDate)
            }

            let completedCount = dayTasks.filter { $0.isCompleted }.count
            let totalCount = dayTasks.count
            let rate = totalCount > 0 ? Double(completedCount) / Double(totalCount) : 0

            completionRates.append((date: date, rate: rate))
        }

        return completionRates
    }

    /// Get most productive days
    func getMostProductiveDays() async throws -> [String: Int] {
        let tasks = try persistenceService.loadTasks()
        let calendar = Calendar.current

        let completedTasks = tasks.filter { $0.isCompleted }
        let dayNames = ["Pazar", "Pazartesi", "Salı", "Çarşamba", "Perşembe", "Cuma", "Cumartesi"]

        var productiveDays: [String: Int] = [:]

        for task in completedTasks {
            guard let completedAt = task.completedAt else { continue }
            let weekday = calendar.component(.weekday, from: completedAt) - 1 // 0 = Sunday
            let dayName = dayNames[weekday]
            productiveDays[dayName, default: 0] += 1
        }

        return productiveDays
    }

    /// Get average tasks per day
    func getAverageTasksPerDay(days: Int = 30) async throws -> Double {
        let tasks = try persistenceService.loadTasks()
        let calendar = Calendar.current
        let now = Date()
        let startDate = calendar.date(byAdding: .day, value: -days, to: now)!

        let recentTasks = tasks.filter { $0.createdAt >= startDate }
        return Double(recentTasks.count) / Double(days)
    }

    /// Get streak information
    func getCurrentStreak() async throws -> Int {
        let tasks = try persistenceService.loadTasks()
        let calendar = Calendar.current

        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())

        while true {
            let dayStart = currentDate
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: dayStart)!

            let dayInterval = DateInterval(start: dayStart, end: dayEnd)
            let dayTasks = tasks.filter { task in
                guard let dueDate = task.dueDate else { return false }
                return dayInterval.contains(dueDate) && task.isCompleted
            }

            if dayTasks.isEmpty {
                break
            }

            streak += 1
            currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
        }

        return streak
    }
}
