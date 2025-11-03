//
//  OnboardingView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var showWelcomeAnimation = false

    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.appPrimary.opacity(0.1), Color.appPrimary.opacity(0.05)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: Theme.Spacing.xxl) {
                // Progress indicator
                progressIndicator

                // Page content
                pageContent

                // Navigation buttons
                navigationButtons
            }
            .padding(.horizontal, Theme.Layout.screenPadding)
            .padding(.vertical, Theme.Spacing.large)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                showWelcomeAnimation = true
            }
        }
    }

    // MARK: - Subviews

    private var progressIndicator: some View {
        HStack(spacing: Theme.Spacing.small) {
            ForEach(0..<3) { index in
                Capsule()
                    .fill(index <= viewModel.currentPage ? Color.appPrimary : Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .animation(.spring(), value: viewModel.currentPage)
            }
        }
        .frame(width: 60)
    }

    private var pageContent: some View {
        let pageData = viewModel.pageData(for: viewModel.currentPage)

        return VStack(spacing: Theme.Spacing.xl) {
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
            .scaleEffect(showWelcomeAnimation ? 1 : 0.5)
            .opacity(showWelcomeAnimation ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: showWelcomeAnimation)

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
            .opacity(showWelcomeAnimation ? 1 : 0)
            .offset(y: showWelcomeAnimation ? 0 : 20)
            .animation(.easeOut(duration: 0.6).delay(0.2), value: showWelcomeAnimation)

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
                .opacity(showWelcomeAnimation ? 1 : 0)
                .offset(y: showWelcomeAnimation ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.4), value: showWelcomeAnimation)
            }

            Spacer()
        }
    }

    private var navigationButtons: some View {
        VStack(spacing: Theme.Spacing.medium) {
            // Primary button
            if let buttonText = viewModel.pageData(for: viewModel.currentPage).buttonText {
                Button(action: {
                    viewModel.completeOnboarding()
                }) {
                    Text(buttonText)
                        .font(.themeHeadline())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: Theme.Layout.buttonHeight)
                        .background(Color.appPrimary)
                        .themeCornerRadius(Theme.BorderRadius.medium)
                }
                .buttonStylePrimary()
            }

            // Secondary navigation
            HStack {
                // Skip button (only on first two pages)
                if !viewModel.isLastPage {
                    Button(action: {
                        viewModel.skipToEnd()
                    }) {
                        Text("Atla")
                            .font(.themeCallout())
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                // Page indicators with navigation
                HStack(spacing: Theme.Spacing.small) {
                    if !viewModel.isFirstPage {
                        Button(action: {
                            viewModel.previousPage()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appPrimary)
                        }
                    }

                    Text("\(viewModel.currentPage + 1)/3")
                        .font(.themeCaption1())
                        .foregroundColor(.secondary)

                    if !viewModel.isLastPage {
                        Button(action: {
                            viewModel.nextPage()
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.appPrimary)
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .previewDisplayName("Onboarding")
    }
}
