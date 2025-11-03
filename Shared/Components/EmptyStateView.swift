//
//  EmptyStateView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct EmptyStateView: View {
    let title: String
    let message: String
    let imageName: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        title: String,
        message: String,
        imageName: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.imageName = imageName
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            Spacer()

            // Image
            Image(systemName: imageName)
                .font(.system(size: 64))
                .foregroundColor(.secondary.opacity(0.5))

            // Text content
            VStack(spacing: Theme.Spacing.small) {
                Text(title)
                    .font(.themeTitle2())
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.themeBody())
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }

            // Action button
            if let actionTitle = actionTitle, let action = action {
                CustomButton(title: actionTitle, action: action)
                    .frame(width: 200)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Theme.Layout.screenPadding)
    }
}

// MARK: - Convenience Initializers

extension EmptyStateView {
    init(title: String, message: String, imageName: String) {
        self.init(title: title, message: message, imageName: imageName, actionTitle: nil, action: nil)
    }
}

// MARK: - Predefined Empty States

extension EmptyStateView {
    static func noPets(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            title: "Henüz pet eklenmemiş",
            message: "İlk evcil hayvanınızı ekleyerek bakım yolculuğunuza başlayın",
            imageName: "pawprint",
            actionTitle: "Pet Ekle",
            action: action
        )
    }

    static func noTasks(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            title: "Görev bulunamadı",
            message: "Yeni görevler ekleyerek petlerinizin bakımını organize edin",
            imageName: "checkmark.circle",
            actionTitle: "Görev Ekle",
            action: action
        )
    }

    static func noReminders(action: @escaping () -> Void) -> EmptyStateView {
        EmptyStateView(
            title: "Hatırlatıcı yok",
            message: "Önemli tarihleri hatırlatmak için hatırlatıcılar oluşturun",
            imageName: "bell",
            actionTitle: "Hatırlatıcı Ekle",
            action: action
        )
    }

    static func noData(title: String, message: String) -> EmptyStateView {
        EmptyStateView(
            title: title,
            message: message,
            imageName: "doc.text.magnifyingglass"
        )
    }
}

// MARK: - Preview

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: Theme.Spacing.xl) {
            EmptyStateView.noPets(action: {})
            EmptyStateView.noTasks(action: {})
            EmptyStateView.noReminders(action: {})
        }
        .previewLayout(.sizeThatFits)
        .previewDisplayName("Empty States")
    }
}
