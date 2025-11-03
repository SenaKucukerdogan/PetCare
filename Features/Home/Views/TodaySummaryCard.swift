//
//  TodaySummaryCard.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct TodaySummaryCard: View {
    let pendingTasks: Int
    let completedTasks: Int
    let overdueTasks: Int

    private var totalTasks: Int {
        pendingTasks + completedTasks
    }

    private var completionRate: Double {
        totalTasks > 0 ? Double(completedTasks) / Double(totalTasks) : 0
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Bugünkü İlerleme")
                        .font(.themeHeadline())
                        .foregroundColor(.primary)

                    Text("\(completedTasks)/\(totalTasks) görev tamamlandı")
                        .font(.themeCaption1())
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Progress circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 6)
                        .frame(width: 50, height: 50)

                    Circle()
                        .trim(from: 0, to: completionRate)
                        .stroke(
                            completionRateColor,
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 50, height: 50)
                        .rotationEffect(.degrees(-90))

                    Text("\(Int(completionRate * 100))%")
                        .font(.themeCaption2())
                        .foregroundColor(.primary)
                        .fontWeight(.semibold)
                }
            }

            // Stats
            HStack(spacing: Theme.Spacing.large) {
                statItem(
                    value: pendingTasks,
                    label: "Bekleyen",
                    color: .appPrimary
                )

                statItem(
                    value: completedTasks,
                    label: "Tamamlanan",
                    color: .success
                )

                statItem(
                    value: overdueTasks,
                    label: "Geciken",
                    color: overdueTasks > 0 ? .error : .success
                )
            }
        }
        .cardStyle()
        .horizontalPadding()
    }

    private var completionRateColor: Color {
        switch completionRate {
        case 0..<0.3: return .error
        case 0.3..<0.7: return .warning
        default: return .success
        }
    }

    private func statItem(value: Int, label: String, color: Color) -> some View {
        VStack(spacing: Theme.Spacing.xxs) {
            Text("\(value)")
                .font(.themeTitle3())
                .foregroundColor(color)
                .fontWeight(.semibold)

            Text(label)
                .font(.themeCaption2())
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

struct TodaySummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        TodaySummaryCard(pendingTasks: 3, completedTasks: 2, overdueTasks: 1)
            .previewLayout(.sizeThatFits)
            .horizontalPadding()
            .previewDisplayName("Today Summary - With Overdue")

        TodaySummaryCard(pendingTasks: 1, completedTasks: 4, overdueTasks: 0)
            .previewLayout(.sizeThatFits)
            .horizontalPadding()
            .previewDisplayName("Today Summary - All Good")
    }
}
