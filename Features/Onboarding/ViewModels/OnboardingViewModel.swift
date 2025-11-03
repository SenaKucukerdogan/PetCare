//
//  OnboardingViewModel.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import Foundation
import SwiftUI

/// ViewModel for onboarding flow
@MainActor
class OnboardingViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var currentPage = 0
    @Published var isCompleted = false

    // MARK: - Private Properties
    private let persistenceService = PersistenceService.shared
    private let totalPages = 3

    // MARK: - Computed Properties
    var isFirstPage: Bool {
        currentPage == 0
    }

    var isLastPage: Bool {
        currentPage == totalPages - 1
    }

    var progress: Double {
        Double(currentPage + 1) / Double(totalPages)
    }

    // MARK: - Public Methods

    /// Move to next page
    func nextPage() {
        guard !isLastPage else { return }
        withAnimation(.easeInOut) {
            currentPage += 1
        }
    }

    /// Move to previous page
    func previousPage() {
        guard !isFirstPage else { return }
        withAnimation(.easeInOut) {
            currentPage -= 1
        }
    }

    /// Skip to last page
    func skipToEnd() {
        withAnimation(.easeInOut) {
            currentPage = totalPages - 1
        }
    }

    /// Complete onboarding
    func completeOnboarding() {
        persistenceService.markFirstLaunchComplete()
        withAnimation(.easeInOut) {
            isCompleted = true
        }
    }

    /// Get page data for current page
    func pageData(for page: Int) -> OnboardingPageData {
        onboardingPages[page]
    }
}

// MARK: - Onboarding Page Data

struct OnboardingPageData {
    let title: String
    let subtitle: String
    let description: String
    let imageName: String
    let buttonText: String?
    let features: [String]?

    static let welcome = OnboardingPageData(
        title: "PetCare'e Hoş Geldiniz",
        subtitle: "Evcil hayvanlarınızın bakımını kolaylaştırın",
        description: "PetCare ile evcil hayvanlarınızın tüm ihtiyaçlarını takip edin, hatırlatıcılar ayarlayın ve sevdiklerinizin sağlığını koruyun.",
        imageName: "pawprint.fill",
        buttonText: nil,
        features: nil
    )

    static let features = OnboardingPageData(
        title: "Tüm Özellikler Tek Uygulamada",
        subtitle: "Kapsamlı pet bakım yönetimi",
        description: "Görevleri takip edin, aşıları yönetin, ilaçları hatırlayın ve çok daha fazlası...",
        imageName: "star.fill",
        buttonText: nil,
        features: [
            "Görev ve hatırlatıcı yönetimi",
            "Aşı ve ilaç takibi",
            "Fotoğraf galerisi",
            "İstatistikler ve raporlar",
            "Çoklu pet desteği"
        ]
    )

    static let getStarted = OnboardingPageData(
        title: "Haydi Başlayalım!",
        subtitle: "İlk evcil hayvanınızı ekleyin",
        description: "Artık PetCare ile evcil hayvanlarınızın bakımını profesyonelce yönetebilirsiniz.",
        imageName: "checkmark.circle.fill",
        buttonText: "Başla",
        features: nil
    )
}

// MARK: - Private Data

private let onboardingPages: [OnboardingPageData] = [
    .welcome,
    .features,
    .getStarted
]
