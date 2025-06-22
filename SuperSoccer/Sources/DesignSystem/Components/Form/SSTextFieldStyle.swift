//
//  SSTextFieldStyle.swift
//  SuperSoccer
//
//  Created by Wesley on 7/8/24.
//

import SwiftUI

public struct SSTextFieldStyle: TextFieldStyle {
    @Environment(\.ssTheme) private var theme
    
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(theme.fonts.body)
            .padding(theme.spacing.medium)
            .background(theme.colors.background)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                    .stroke(theme.colors.primaryCyan, lineWidth: 2)
            )
            .foregroundColor(theme.colors.textPrimary)
    }
} 