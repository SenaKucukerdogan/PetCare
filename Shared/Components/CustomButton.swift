//
//  CustomButton.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    let style: ButtonStyle
    let isEnabled: Bool
    let isLoading: Bool

    init(
        title: String,
        style: ButtonStyle = .primary,
        isEnabled: Bool = true,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.style = style
        self.isEnabled = isEnabled
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button(action: {
            guard isEnabled && !isLoading else { return }
            action()
        }) {
            ZStack {
                // Background
                style.backgroundColor(isEnabled: isEnabled)
                    .cornerRadius(Theme.BorderRadius.medium.rawValue)
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.BorderRadius.medium.rawValue)
                            .stroke(style.borderColor, lineWidth: style.borderWidth)
                    )

                // Content
                HStack(spacing: Theme.Spacing.small) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: style.contentColor(isEnabled: isEnabled)))
                    } else {
                        Text(title)
                            .font(style.font)
                            .foregroundColor(style.contentColor(isEnabled: isEnabled))
                    }
                }
                .padding(.horizontal, Theme.Layout.cardPadding)
                .padding(.vertical, Theme.Spacing.medium)
            }
        }
        .frame(height: Theme.Layout.buttonHeight)
        .disabled(!isEnabled || isLoading)
        .opacity((isEnabled && !isLoading) ? 1.0 : 0.5)
        .animation(.easeInOut(duration: Theme.Animation.fast), value: isEnabled)
        .animation(.easeInOut(duration: Theme.Animation.fast), value: isLoading)
    }
}

// MARK: - Button Styles

enum ButtonStyle {
    case primary
    case secondary
    case destructive
    case outline

    var font: Font {
        switch self {
        case .primary, .secondary, .destructive:
            return .themeHeadline()
        case .outline:
            return .themeCallout()
        }
    }

    func backgroundColor(isEnabled: Bool) -> Color {
        switch self {
        case .primary:
            return isEnabled ? .appPrimary : .disabled
        case .secondary:
            return isEnabled ? .appPrimary.opacity(0.1) : .disabled.opacity(0.1)
        case .destructive:
            return isEnabled ? .error : .disabled
        case .outline:
            return .clear
        }
    }

    var borderColor: Color {
        switch self {
        case .primary, .secondary, .destructive:
            return .clear
        case .outline:
            return .appPrimary
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .outline:
            return 1
        default:
            return 0
        }
    }

    func contentColor(isEnabled: Bool) -> Color {
        switch self {
        case .primary, .destructive:
            return .white
        case .secondary:
            return isEnabled ? .appPrimary : .disabled
        case .outline:
            return isEnabled ? .appPrimary : .disabled
        }
    }
}

// MARK: - Convenience Initializers

extension CustomButton {
    init(title: String, action: @escaping () -> Void) {
        self.init(title: title, style: .primary, isEnabled: true, isLoading: false, action: action)
    }
}

// MARK: - Preview

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Theme.Spacing.medium) {
            CustomButton(title: "Primary Button", action: {})
            CustomButton(title: "Secondary Button", style: .secondary, action: {})
            CustomButton(title: "Destructive Button", style: .destructive, action: {})
            CustomButton(title: "Outline Button", style: .outline, action: {})
            CustomButton(title: "Disabled Button", style: .primary, isEnabled: false, action: {})
            CustomButton(title: "Loading Button", style: .primary, isLoading: true, action: {})
        }
        .horizontalPadding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Custom Buttons")
    }
}
