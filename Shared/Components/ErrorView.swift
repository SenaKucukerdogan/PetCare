//
//  ErrorView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: Theme.Spacing.large) {
            Spacer()

            // Error icon
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 64))
                .foregroundColor(.error)

            // Error message
            VStack(spacing: Theme.Spacing.medium) {
                Text("Bir hata oluştu")
                    .font(.themeTitle2())
                    .foregroundColor(.primary)

                Text(error.localizedDescription)
                    .font(.themeBody())
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .padding(.horizontal)
            }

            // Retry button
            CustomButton(title: "Tekrar Dene", action: retryAction)
                .frame(width: 150)

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Theme.Layout.screenPadding)
    }
}

// MARK: - Error Types

enum AppError: LocalizedError {
    case networkError
    case dataError
    case saveError
    case loadError
    case validationError(String)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "İnternet bağlantınızı kontrol edin"
        case .dataError:
            return "Veri işlenirken hata oluştu"
        case .saveError:
            return "Veri kaydedilirken hata oluştu"
        case .loadError:
            return "Veri yüklenirken hata oluştu"
        case .validationError(let message):
            return message
        case .unknownError:
            return "Bilinmeyen bir hata oluştu"
        }
    }
}

// MARK: - Preview

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: AppError.networkError, retryAction: {})
            .previewLayout(.sizeThatFits)
            .frame(height: 400)
            .previewDisplayName("Error View")
    }
}
