//
//  HomeView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showAddPet = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: Theme.Spacing.large) {
                    // Header
                    headerSection

                    // Quick stats
                    quickStatsSection

                    // Today's summary
                    todaysSummarySection

                    // Active pets
                    activePetsSection

                    // Upcoming tasks
                    upcomingTasksSection
                }
                .padding(.vertical, Theme.Spacing.medium)
            }
            .navigationTitle("PetCare")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.adaptiveGroupedBackground.ignoresSafeArea())
            .refreshable {
                viewModel.refreshData()
            }
            .sheet(isPresented: $showAddPet) {
                // AddPetView() - Will be implemented later
                Text("Add Pet View - Coming Soon")
            }
        }
        .loadingOverlay(isLoading: viewModel.isLoading)
        .errorOverlay(error: viewModel.error) {
            viewModel.refreshData()
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.small) {
            Text("Merhaba! 👋")
                .font(.themeTitle3())
                .foregroundColor(.primary)

            Text("Evcil hayvanlarınızın bakımı için bugün ne yapacaksınız?")
                .font(.themeBody())
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .horizontalPadding()
    }

    // MARK: - Quick Stats Section
    private var quickStatsSection: some View {
        VStack(spacing: Theme.Spacing.medium) {
            HStack {
                statCard(
                    title: "Aktif Petler",
                    value: "\(viewModel.totalActivePetsCount)",
                    icon: "pawprint.fill",
                    color: .appPrimary
                )

                statCard(
                    title: "Bugünkü Görevler",
                    value: "\(viewModel.todaysPendingTasksCount)",
                    icon: "checkmark.circle.fill",
                    color: viewModel.overdueTasksCount > 0 ? .error : .success
                )
            }

            HStack {
                statCard(
                    title: "Hatırlatıcılar",
                    value: "\(viewModel.todaysActiveRemindersCount)",
                    icon: "bell.fill",
                    color: .warning
                )

                statCard(
                    title: "Tamamlanan",
                    value: "\(viewModel.todaysCompletedTasksCount)",
                    icon: "star.fill",
                    color: .success
                )
            }
        }
        .horizontalPadding()
    }

    // MARK: - Today's Summary Section
    private var todaysSummarySection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            sectionHeader(title: "Bugünkü Özet", icon: "calendar")

            TodaySummaryCard(
                pendingTasks: viewModel.todaysPendingTasksCount,
                completedTasks: viewModel.todaysCompletedTasksCount,
                overdueTasks: viewModel.overdueTasksCount
            )
        }
        .horizontalPadding()
    }

    // MARK: - Active Pets Section
    private var activePetsSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            HStack {
                sectionHeader(title: "Aktif Petleriniz", icon: "heart.fill")

                Spacer()

                Button(action: {
                    showAddPet = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.appPrimary)
                }
            }

            if viewModel.activePets.isEmpty {
                emptyStateView(
                    title: "Henüz pet eklenmemiş",
                    subtitle: "İlk evcil hayvanınızı ekleyerek başlayın",
                    icon: "pawprint"
                )
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: Theme.Spacing.medium) {
                        ForEach(viewModel.activePets) { pet in
                            petCard(for: pet)
                        }
                    }
                    .padding(.horizontal, Theme.Spacing.small)
                }
            }
        }
        .horizontalPadding()
    }

    // MARK: - Upcoming Tasks Section
    private var upcomingTasksSection: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            sectionHeader(title: "Yaklaşan Görevler", icon: "clock.fill")

            if viewModel.upcomingTasks.isEmpty {
                emptyStateView(
                    title: "Yaklaşan görev yok",
                    subtitle: "Yeni görevler eklendiğinde burada görünecek",
                    icon: "calendar.badge.exclamationmark"
                )
            } else {
                VStack(spacing: Theme.Spacing.small) {
                    ForEach(viewModel.upcomingTasks.prefix(3)) { task in
                        taskRow(for: task)
                    }
                }
            }
        }
        .horizontalPadding()
    }

    // MARK: - Helper Views

    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: Theme.Spacing.small) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)

                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.system(size: 20))
            }

            Text(value)
                .font(.themeTitle2())
                .foregroundColor(.primary)

            Text(title)
                .font(.themeCaption1())
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .cardStyle()
        .frame(height: 100)
    }

    private func sectionHeader(title: String, icon: String) -> some View {
        HStack(spacing: Theme.Spacing.small) {
            Image(systemName: icon)
                .foregroundColor(.appPrimary)

            Text(title)
                .font(.themeHeadline())
                .foregroundColor(.primary)
        }
    }

    private func petCard(for pet: Pet) -> some View {
        VStack(spacing: Theme.Spacing.small) {
            ZStack {
                Circle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 60, height: 60)

                Text(String(pet.name.prefix(1)))
                    .font(.themeTitle1())
                    .foregroundColor(.primary)
            }

            Text(pet.name)
                .font(.themeCallout())
                .foregroundColor(.primary)

            Text(pet.type.displayName)
                .font(.themeCaption2())
                .foregroundColor(.secondary)
        }
        .cardStyle()
        .frame(width: 80)
    }

    private func taskRow(for task: Task) -> some View {
        HStack(spacing: Theme.Spacing.medium) {
            Circle()
                .fill(Color.forCategory(task.category))
                .frame(width: 8, height: 8)

            VStack(alignment: .leading, spacing: 2) {
                Text(task.title)
                    .font(.themeCallout())
                    .foregroundColor(.primary)

                if let dueDate = task.dueDate {
                    Text(dueDate.relativeDateString)
                        .font(.themeCaption2())
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isCompleted ? .success : .secondary)
        }
        .padding(.vertical, Theme.Spacing.small)
        .cardStyle()
    }

    private func emptyStateView(title: String, subtitle: String, icon: String) -> some View {
        VStack(spacing: Theme.Spacing.medium) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(.secondary.opacity(0.5))

            VStack(spacing: Theme.Spacing.small) {
                Text(title)
                    .font(.themeHeadline())
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.themeBody())
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, Theme.Spacing.xl)
        .cardStyle()
    }
}

// MARK: - Preview

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .previewDisplayName("Home Dashboard")
    }
}
