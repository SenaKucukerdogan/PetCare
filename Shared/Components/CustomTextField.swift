//
//  CustomTextField.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let isSecure: Bool
    let errorMessage: String?

    @State private var isEditing = false

    init(
        placeholder: String,
        text: Binding<String>,
        keyboardType: UIKeyboardType = .default,
        isSecure: Bool = false,
        errorMessage: String? = nil
    ) {
        self.placeholder = placeholder
        self._text = text
        self.keyboardType = keyboardType
        self.isSecure = isSecure
        self.errorMessage = errorMessage
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Theme.Spacing.xxs) {
            // Text field container
            ZStack(alignment: .leading) {
                // Placeholder
                if text.isEmpty && !isEditing {
                    Text(placeholder)
                        .foregroundColor(.secondary.opacity(0.7))
                        .font(.themeBody())
                }

                // Text field
                if isSecure {
                    SecureField("", text: $text)
                        .font(.themeBody())
                        .foregroundColor(.primary)
                        .keyboardType(keyboardType)
                        .textContentType(.none)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField("", text: $text)
                        .font(.themeBody())
                        .foregroundColor(.primary)
                        .keyboardType(keyboardType)
                        .textContentType(.none)
                        .autocapitalization(.words)
                        .disableAutocorrection(false)
                }
            }
            .padding(.horizontal, Theme.Layout.cardPadding)
            .padding(.vertical, Theme.Spacing.medium)
            .background(fieldBackground)
            .cornerRadius(Theme.BorderRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.BorderRadius.medium)
                    .stroke(fieldBorderColor, lineWidth: 1)
            )
            .onTapGesture {
                isEditing = true
            }

            // Error message
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .font(.themeCaption2())
                    .foregroundColor(.error)
                    .padding(.horizontal, Theme.Spacing.xxs)
            }
        }
    }

    private var fieldBackground: Color {
        isEditing ? .adaptiveBackground : .adaptiveSecondaryBackground
    }

    private var fieldBorderColor: Color {
        if let _ = errorMessage {
            return .error
        } else if isEditing {
            return .appPrimary
        } else {
            return .border
        }
    }
}

// MARK: - Convenience Initializers

extension CustomTextField {
    init(placeholder: String, text: Binding<String>) {
        self.init(placeholder: placeholder, text: text, keyboardType: .default, isSecure: false, errorMessage: nil)
    }

    init(placeholder: String, text: Binding<String>, errorMessage: String?) {
        self.init(placeholder: placeholder, text: text, keyboardType: .default, isSecure: false, errorMessage: errorMessage)
    }
}

// MARK: - Preview

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Theme.Spacing.medium) {
            CustomTextField(placeholder: "Ad Soyad", text: .constant(""))
            CustomTextField(placeholder: "E-posta", text: .constant("user@example.com"))
            CustomTextField(placeholder: "Şifre", text: .constant(""), isSecure: true)
            CustomTextField(placeholder: "Telefon", text: .constant(""), keyboardType: .phonePad)
            CustomTextField(placeholder: "Geçersiz alan", text: .constant(""), errorMessage: "Bu alan zorunludur")
        }
        .horizontalPadding()
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Custom Text Fields")
    }
}
