//
//  MainTabView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab
            NavigationView {
                HomeView()
            }
            .tabItem {
                Label("Ana Sayfa", systemImage: "house.fill")
            }
            .tag(0)

            // Tasks Tab
            NavigationView {
                Text("Görevler - Coming Soon")
                    .navigationTitle("Görevler")
            }
            .tabItem {
                Label("Görevler", systemImage: "checkmark.circle.fill")
            }
            .tag(1)

            // Pets Tab
            NavigationView {
                Text("Petler - Coming Soon")
                    .navigationTitle("Petlerim")
            }
            .tabItem {
                Label("Petler", systemImage: "pawprint.fill")
            }
            .tag(2)

            // Reminders Tab
            NavigationView {
                Text("Hatırlatıcılar - Coming Soon")
                    .navigationTitle("Hatırlatıcılar")
            }
            .tabItem {
                Label("Hatırlatıcılar", systemImage: "bell.fill")
            }
            .tag(3)

            // Statistics Tab
            NavigationView {
                Text("İstatistikler - Coming Soon")
                    .navigationTitle("İstatistikler")
            }
            .tabItem {
                Label("İstatistikler", systemImage: "chart.bar.fill")
            }
            .tag(4)
        }
        .accentColor(.appPrimary)
    }
}

// MARK: - Preview

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .previewDisplayName("Main Tab View")
    }
}
