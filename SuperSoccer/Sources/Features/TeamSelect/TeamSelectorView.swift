//
//  TeamSelectorView.swift
//  SuperSoccer
//
//  Created by Wesley on 7/8/24.
//

import SwiftUI

struct TeamSelectorView: View {
    @Environment(\.ssTheme) private var theme
    
    let title: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            SSLabel.headline(title)
            Spacer()
            SSTextButton.make(title: buttonTitle, action: action)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                .stroke(theme.colors.primaryCyan, lineWidth: 2)
        )
    }
} 