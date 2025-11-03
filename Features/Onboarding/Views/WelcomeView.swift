//
//  WelcomeView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct WelcomeView: View {
    @State private var showContent = false
    @State private var showButton = false

    var body: some View {
        ZStack {
            // Background
            Color.appPrimary
                .ignoresSafeArea()

            VStack(spacing: Theme.Spacing.xxl) {
                Spacer()

                // Logo/Icon
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 150, height: 150)

                    Image(systemName: "pawprint.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }
                .scaleEffect(showContent ? 1 : 0.5)
                .opacity(showContent ? 1 : 0)
                .animation(.spring(response: 0.8, dampingFraction: 0.6), value: showContent)

                // Text content
                VStack(spacing: Theme.Spacing.medium) {
                    Text("PetCare")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)

                    Text("Evcil hayvanlarınızın bakımını\nkolay ve düzenli tutun")
                        .font(.themeTitle3())
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.6).delay(0.3), value: showContent)

                Spacer()

                // Get started button
                VStack(spacing: Theme.Spacing.medium) {
                    Button(action: {
                        // This will be handled by parent view
                    }) {
                        Text("Başlayalım")
                            .font(.themeHeadline())
                            .foregroundColor(.appPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: Theme.Layout.buttonHeight)
                            .background(Color.white)
                            .themeCornerRadius(Theme.BorderRadius.medium)
                    }
                    .opacity(showButton ? 1 : 0)
                    .offset(y: showButton ? 0 : 20)
                    .animation(.easeOut(duration: 0.4).delay(0.6), value: showButton)

                    Text("Devam ederek şartlarımızı kabul etmiş olursunuz")
                        .font(.themeCaption2())
                        .foregroundColor(.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .opacity(showButton ? 1 : 0)
                .animation(.easeOut(duration: 0.4).delay(0.5), value: showButton)
            }
            .padding(.horizontal, Theme.Layout.screenPadding)
            .padding(.vertical, Theme.Spacing.large)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showContent = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    showButton = true
                }
            }
        }
    }
}

// MARK: - Preview

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .previewDisplayName("Welcome Screen")
    }
}
