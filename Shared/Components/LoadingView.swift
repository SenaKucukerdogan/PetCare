//
//  LoadingView.swift
//  PetCare
//
//  Created by Sena Küçükerdoğan on 3.11.2025.
//

import SwiftUI

struct LoadingView: View {
    let message: String?

    init(message: String? = nil) {
        self.message = message
    }

    var body: some View {
        VStack(spacing: Theme.Spacing.medium) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .appPrimary))
                .scaleEffect(1.5)

            if let message = message {
                Text(message)
                    .font(.themeBody())
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.adaptiveBackground.opacity(0.8))
    }
}

// MARK: - Loading States

enum LoadingState {
    case idle
    case loading(message: String? = nil)
    case error(Error)
    case loaded

    var isLoading: Bool {
        switch self {
        case .loading: return true
        default: return false
        }
    }

    var error: Error? {
        switch self {
        case .error(let error): return error
        default: return nil
        }
    }
}

// MARK: - Preview

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView(message: "Yükleniyor...")
            .previewLayout(.sizeThatFits)
            .frame(height: 200)
            .previewDisplayName("Loading View")
    }
}
