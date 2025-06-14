//
//  SSTheme.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

/// Central theme manager for SuperSoccer Design System
/// Provides access to colors, fonts, spacing, and other design tokens
struct SSTheme {
    // MARK: - Design Tokens
    let colors: SSColors
    let fonts = SSFonts()
    let spacing = SSSpacing()
    let cornerRadius = SSCornerRadius()
    
    init(colorScheme: ColorScheme) {
        self.colors = SSColors(colorScheme: colorScheme)
    }
}

// MARK: - Environment Integration
struct SSThemeKey: EnvironmentKey {
    static let defaultValue = SSTheme(colorScheme: .light)
}

extension EnvironmentValues {
    var ssTheme: SSTheme {
        get { self[SSThemeKey.self] }
        set { self[SSThemeKey.self] = newValue }
    }
}


// MARK: - Theme Provider View
/// A view that automatically provides the correct theme based on the current color scheme
struct SSThemeProvider<Content: View>: View {
    @Environment(\.colorScheme) private var colorScheme
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .environment(\.ssTheme, SSTheme(colorScheme: colorScheme))
    }
}
