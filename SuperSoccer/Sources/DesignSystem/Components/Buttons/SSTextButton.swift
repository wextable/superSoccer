//
//  SSTextButton.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

// MARK: - ViewModel
struct SSTextButtonViewModel {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    init(title: String, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }
}

// MARK: - Component
struct SSTextButton: View {
    let viewModel: SSTextButtonViewModel
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        Button(action: viewModel.action) {
            Text(viewModel.title)
                .font(theme.fonts.buttonSecondary)
                .foregroundColor(viewModel.isEnabled ? theme.colors.primaryCyan : theme.colors.textSecondary)
                .padding(.vertical, theme.spacing.small)
        }
        .disabled(!viewModel.isEnabled)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isEnabled)
    }
}

// MARK: - Factory Method
extension SSTextButton {
    static func make(
        title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> SSTextButton {
        SSTextButton(
            viewModel: SSTextButtonViewModel(
                title: title,
                isEnabled: isEnabled,
                action: action
            )
        )
    }
}

// MARK: - Debug Extensions
#if DEBUG
extension SSTextButtonViewModel {
    static func make(
        title: String = "Text Button",
        isEnabled: Bool = true,
        action: @escaping () -> Void = {}
    ) -> Self {
        self.init(
            title: title,
            isEnabled: isEnabled,
            action: action
        )
    }
}
#endif
