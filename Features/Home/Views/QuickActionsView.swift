//
//  QuickActionsView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct QuickActionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
            Text("Hızlı İşlemler")
                .font(.themeHeadline())
                .foregroundColor(.primary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: Theme.Spacing.medium) {
                    quickActionButton(
                        title: "Pet Ekle",
                        icon: "plus.circle.fill",
                        color: .appPrimary
                    )

                    quickActionButton(
                        title: "Görev Ekle",
                        icon: "checkmark.circle.fill",
                        color: .success
                    )

                    quickActionButton(
                        title: "Hatırlatıcı",
                        icon: "bell.fill",
                        color: .warning
                    )

                    quickActionButton(
                        title: "İstatistikler",
                        icon: "chart.bar.fill",
                        color: .purple
                    )
                }
                .padding(.horizontal, Theme.Spacing.small)
            }
        }
    }

    private func quickActionButton(title: String, icon: String, color: Color) -> some View {
        VStack(spacing: Theme.Spacing.small) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 50, height: 50)

                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
            }

            Text(title)
                .font(.themeCaption1())
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(width: 70)
        .onTapGesture {
            // Handle quick action tap
            print("Tapped: \(title)")
        }
    }
}

// MARK: - Preview

struct QuickActionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuickActionsView()
            .previewLayout(.sizeThatFits)
            .horizontalPadding()
            .previewDisplayName("Quick Actions")
    }
}
