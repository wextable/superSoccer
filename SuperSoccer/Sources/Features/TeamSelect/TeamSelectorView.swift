//
//  TeamSelectorView.swift
//  SuperSoccer
//
//  Created by Wesley on 7/8/24.
//

import SwiftUI

struct TeamSelectorViewModel {
    var title: String = "Team:"
    var buttonTitle: String = "Select your team"
}

struct TeamSelectorView: View {
    @Environment(\.ssTheme) private var theme
    let viewModel: TeamSelectorViewModel
    
    let action: () -> Void
    
    var body: some View {
        HStack {
            SSLabel.headline(viewModel.title)
            Spacer()
            SSTextButton.make(title: viewModel.buttonTitle, action: action)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                .stroke(theme.colors.primaryCyan, lineWidth: 2)
        )
    }
} 

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamSelectorViewModel {
    static func make(
        title: String = "Team:",
        buttonTitle: String = "Select your team"
    ) -> Self {
        self.init(
            title: title,
            buttonTitle: buttonTitle
        )
    }
}
#endif
