//
//  OnboardingPageView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct OnboardingPageView: View {
    let pageData: OnboardingPageData
    let isCurrentPage: Bool

    var body: some View {
        VStack(spacing: Theme.Spacing.xl) {
            Spacer()

            // Icon/Image
            ZStack {
                Circle()
                    .fill(Color.appPrimary.opacity(0.1))
                    .frame(width: 120, height: 120)

                Image(systemName: pageData.imageName)
                    .font(.system(size: 48))
                    .foregroundColor(.appPrimary)
            }
            .scaleEffect(isCurrentPage ? 1 : 0.8)
            .opacity(isCurrentPage ? 1 : 0.7)
            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isCurrentPage)

            // Text content
            VStack(spacing: Theme.Spacing.medium) {
                Text(pageData.title)
                    .font(.themeTitle1())
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text(pageData.subtitle)
                    .font(.themeHeadline())
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                Text(pageData.description)
                    .font(.themeBody())
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .opacity(isCurrentPage ? 1 : 0.7)
            .offset(y: isCurrentPage ? 0 : 10)
            .animation(.easeOut(duration: 0.3), value: isCurrentPage)

            // Features list (for features page)
            if let features = pageData.features {
                VStack(alignment: .leading, spacing: Theme.Spacing.medium) {
                    ForEach(features, id: \.self) { feature in
                        HStack(alignment: .top, spacing: Theme.Spacing.medium) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.success)
                                .font(.system(size: 20))

                            Text(feature)
                                .font(.themeCallout())
                                .foregroundColor(.primary)
                        }
                    }
                }
                .opacity(isCurrentPage ? 1 : 0.7)
                .offset(y: isCurrentPage ? 0 : 10)
                .animation(.easeOut(duration: 0.3).delay(0.1), value: isCurrentPage)
            }

            Spacer()
        }
        .padding(.horizontal, Theme.Layout.screenPadding)
    }
}

// MARK: - Preview

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(
            pageData: .features,
            isCurrentPage: true
        )
        .previewDisplayName("Onboarding Page - Features")
    }
}
