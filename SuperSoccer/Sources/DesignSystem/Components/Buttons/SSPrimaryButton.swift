//
//  SSPrimaryButton.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

// MARK: - ViewModel
struct SSPrimaryButtonViewModel {
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
struct SSPrimaryButton: View {
    let viewModel: SSPrimaryButtonViewModel
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        Button(action: viewModel.action) {
            Text(viewModel.title)
                .font(theme.fonts.buttonPrimary)
                .foregroundColor(theme.colors.textInverted)
                .padding(theme.spacing.buttonPadding)
                .frame(maxWidth: .infinity)
        }
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.button)
                .fill(viewModel.isEnabled ? theme.colors.buttonPrimary : theme.colors.buttonDisabled)
        )
        .disabled(!viewModel.isEnabled)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isEnabled)
    }
}

// MARK: - Factory Method
extension SSPrimaryButton {
    static func make(
        title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) -> SSPrimaryButton {
        SSPrimaryButton(
            viewModel: SSPrimaryButtonViewModel(
                title: title,
                isEnabled: isEnabled,
                action: action
            )
        )
    }
}

// MARK: - Debug Extensions
#if DEBUG
extension SSPrimaryButtonViewModel {
    static func make(
        title: String = "Primary Button",
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
