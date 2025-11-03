//
//  View+Extensions.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

extension View {
    // MARK: - Card Styling

    /// Apply card styling with shadow and corner radius
    func cardStyle(cornerRadius: CGFloat = 12, shadowRadius: CGFloat = 4) -> some View {
        self
            .background(Color.cardBackground)
            .cornerRadius(cornerRadius)
            .shadow(color: Color.black.opacity(0.1), radius: shadowRadius, x: 0, y: 2)
    }

    /// Apply elevated card styling
    func elevatedCardStyle() -> some View {
        self
            .background(Color.cardBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    // MARK: - Conditional Modifiers

    /// Apply modifier conditionally
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Apply modifier conditionally with else branch
    @ViewBuilder func `if`<Content: View, ElseContent: View>(
        _ condition: Bool,
        transform: (Self) -> Content,
        else elseTransform: (Self) -> ElseContent
    ) -> some View {
        if condition {
            transform(self)
        } else {
            elseTransform(self)
        }
    }

    // MARK: - Loading States

    /// Show loading overlay
    func loadingOverlay(isLoading: Bool) -> some View {
        self.overlay {
            if isLoading {
                ZStack {
                    Color.black.opacity(0.3)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
                .ignoresSafeArea()
            }
        }
    }

    /// Show loading state with reduced opacity
    func loadingState(isLoading: Bool) -> some View {
        self.opacity(isLoading ? 0.5 : 1.0)
            .disabled(isLoading)
    }

    // MARK: - Error States

    /// Show error overlay
    func errorOverlay(error: Error?, retryAction: @escaping () -> Void) -> some View {
        self.overlay {
            if error != nil {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.error)
                        .padding()

                    Text("Bir hata oluştu")
                        .font(.headline)
                        .foregroundColor(.primary)

                    Text(error?.localizedDescription ?? "Bilinmeyen hata")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button(action: retryAction) {
                        Text("Tekrar Dene")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.appPrimary)
                            .cornerRadius(8)
                    }
                    .padding(.top)
                }
                .padding()
                .background(Color.adaptiveBackground)
                .cornerRadius(16)
                .shadow(radius: 10)
                .padding(.horizontal, 40)
            }
        }
    }

    // MARK: - Accessibility
    // Use SwiftUI's built-in accessibility modifiers directly to avoid shadowing

    // MARK: - Animation

    /// Apply spring animation
    func springAnimation() -> some View {
        self.animation(.spring(response: 0.4, dampingFraction: 0.8), value: UUID())
    }

    /// Apply ease in out animation
    func easeInOutAnimation(duration: Double = 0.3) -> some View {
        self.animation(.easeInOut(duration: duration), value: UUID())
    }

    // MARK: - Layout

    /// Center content with max width
    func centeredMaxWidth(_ width: CGFloat = .infinity) -> some View {
        self.frame(maxWidth: width, alignment: .center)
    }

    /// Apply horizontal padding
    func horizontalPadding(_ padding: CGFloat = 16) -> some View {
        self.padding(.horizontal, padding)
    }

    /// Apply vertical padding
    func verticalPadding(_ padding: CGFloat = 16) -> some View {
        self.padding(.vertical, padding)
    }

    // MARK: - Navigation

    /// Hide navigation bar
    func hideNavigationBar() -> some View {
        self.navigationBarHidden(true)
    }

    // Prefer SwiftUI's built-in navigationTitle and navigationBarTitleDisplayMode

    // MARK: - iOS 15+ Compatibility
    // Removed custom safeAreaPadding to avoid incorrect API usage

    // MARK: - Preview Helpers
    // Intentionally left blank: avoid shadowing SwiftUI's preview helpers
}

// MARK: - View Extensions for Lists

extension View {
    /// Remove list separators
    func listStylePlain() -> some View {
        if #available(iOS 15.0, *) {
            return self.listStyle(.plain)
        } else {
            return self.listStyle(PlainListStyle())
        }
    }

    /// Apply inset grouped list style
    func listStyleInsetGrouped() -> some View {
        if #available(iOS 15.0, *) {
            return self.listStyle(.insetGrouped)
        } else {
            return self.listStyle(InsetGroupedListStyle())
        }
    }
}

// MARK: - View Extensions for Buttons

extension View {
    /// Apply button style
    func buttonStylePrimary() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.appPrimary)
            .cornerRadius(10)
    }

    /// Apply secondary button style
    func buttonStyleSecondary() -> some View {
        self
            .font(.headline)
            .foregroundColor(Color.appPrimary)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.appPrimary.opacity(0.1))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.appPrimary, lineWidth: 1)
            )
    }

    /// Apply destructive button style
    func buttonStyleDestructive() -> some View {
        self
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.error)
            .cornerRadius(10)
    }
}
