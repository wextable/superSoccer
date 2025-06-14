//
//  SSColors.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

/// SuperSoccer color palette inspired by Starbyte Super Soccer (1991)
/// Adapts the classic bright retro colors for modern light/dark mode support
struct SSColors {
    private let colorScheme: ColorScheme
    
    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    
    // MARK: - Primary Colors (Starbyte-inspired)
    
    /// Bright cyan - primary action color
    var primaryCyan: Color {
        colorScheme == .dark 
            ? Color(red: 0, green: 1, blue: 1)           // Full bright cyan in dark mode
            : Color(red: 0, green: 0.8, blue: 0.9)       // Slightly toned down for light mode
    }
    
    /// Bright red - secondary action/alert color
    var primaryRed: Color {
        colorScheme == .dark
            ? Color(red: 1, green: 0, blue: 0)           // Full bright red in dark mode
            : Color(red: 0.9, green: 0, blue: 0)         // Slightly toned down for light mode
    }
    
    /// Bright yellow - accent/highlight color
    var primaryYellow: Color {
        colorScheme == .dark
            ? Color(red: 1, green: 1, blue: 0)           // Full bright yellow in dark mode
            : Color(red: 0.9, green: 0.8, blue: 0)       // Slightly toned down for light mode
    }
    
    /// Bright green - success/positive color
    var primaryGreen: Color {
        colorScheme == .dark
            ? Color(red: 0, green: 1, blue: 0)           // Full bright green in dark mode
            : Color(red: 0, green: 0.8, blue: 0)         // Slightly toned down for light mode
    }
    
    /// Bright blue - information/link color
    var primaryBlue: Color {
        colorScheme == .dark
            ? Color(red: 0, green: 0, blue: 1)           // Full bright blue in dark mode
            : Color(red: 0, green: 0, blue: 0.9)         // Slightly toned down for light mode
    }
    
    /// Bright magenta - special accent color
    var primaryMagenta: Color {
        colorScheme == .dark
            ? Color(red: 1, green: 0, blue: 1)           // Full bright magenta in dark mode
            : Color(red: 0.8, green: 0, blue: 0.8)       // Slightly toned down for light mode
    }
    
    // MARK: - Background Colors
    
    /// Primary background color
    var background: Color {
        colorScheme == .dark
            ? Color(red: 0.05, green: 0.05, blue: 0.1)   // Very dark blue-black
            : Color(red: 0.95, green: 0.95, blue: 0.9)   // Off-white with slight warmth
    }
    
    /// Secondary background color (cards, sections)
    var backgroundSecondary: Color {
        colorScheme == .dark
            ? Color(red: 0.1, green: 0.1, blue: 0.15)    // Dark gray-blue
            : Color.white                                 // Pure white
    }
    
    /// Field/game background color (inspired by soccer field)
    var fieldBackground: Color {
        colorScheme == .dark
            ? Color(red: 0, green: 0.3, blue: 0)         // Dark green
            : Color(red: 0, green: 0.6, blue: 0)         // Bright green
    }
    
    // MARK: - Text Colors
    
    /// Primary text color
    var textPrimary: Color {
        colorScheme == .dark 
            ? Color(red: 1.0, green: 1.0, blue: 1.0)     // Pure white for maximum contrast
            : Color(red: 0.1, green: 0.1, blue: 0.1)     // Near black for light mode
    }
    
    /// Secondary text color
    var textSecondary: Color {
        colorScheme == .dark
            ? Color(red: 0.9, green: 0.9, blue: 0.9)     // Much brighter gray for better visibility
            : Color(red: 0.5, green: 0.5, blue: 0.5)     // Medium gray for light mode
    }
    
    /// Inverted text color (for use on colored backgrounds)
    var textInverted: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    // MARK: - Button Colors
    
    /// Primary button background
    var buttonPrimary: Color { primaryCyan }
    
    /// Secondary button background
    var buttonSecondary: Color { primaryRed }
    
    /// Tertiary button background
    var buttonTertiary: Color { primaryYellow }
    
    /// Disabled button background
    var buttonDisabled: Color {
        colorScheme == .dark
            ? Color(red: 0.3, green: 0.3, blue: 0.3)     // Dark gray
            : Color(red: 0.8, green: 0.8, blue: 0.8)     // Light gray
    }
    
    // MARK: - Border Colors
    
    /// Primary border color
    var border: Color {
        colorScheme == .dark
            ? Color(red: 0.3, green: 0.3, blue: 0.3)     // Dark gray
            : Color(red: 0.8, green: 0.8, blue: 0.8)     // Light gray
    }
    
    /// Accent border color
    var borderAccent: Color { primaryCyan }
}

// MARK: - Static Color Access
extension SSColors {
    /// Provides static access to colors without environment dependency
    /// Use this for previews or when environment is not available
    static func colors(for colorScheme: ColorScheme) -> StaticSSColors {
        return StaticSSColors(colorScheme: colorScheme)
    }
}

/// Static version of SSColors that doesn't depend on environment
struct StaticSSColors {
    let colorScheme: ColorScheme
    
    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
    }
    
    // MARK: - Primary Colors (Starbyte-inspired)
    
    var primaryCyan: Color {
        colorScheme == .dark 
            ? Color(red: 0, green: 1, blue: 1)
            : Color(red: 0, green: 0.8, blue: 0.9)
    }
    
    var primaryRed: Color {
        colorScheme == .dark
            ? Color(red: 1, green: 0, blue: 0)
            : Color(red: 0.9, green: 0, blue: 0)
    }
    
    var primaryYellow: Color {
        colorScheme == .dark
            ? Color(red: 1, green: 1, blue: 0)
            : Color(red: 0.9, green: 0.8, blue: 0)
    }
    
    var primaryGreen: Color {
        colorScheme == .dark
            ? Color(red: 0, green: 1, blue: 0)
            : Color(red: 0, green: 0.8, blue: 0)
    }
    
    var primaryBlue: Color {
        colorScheme == .dark
            ? Color(red: 0, green: 0, blue: 1)
            : Color(red: 0, green: 0, blue: 0.9)
    }
    
    var primaryMagenta: Color {
        colorScheme == .dark
            ? Color(red: 1, green: 0, blue: 1)
            : Color(red: 0.8, green: 0, blue: 0.8)
    }
    
    // MARK: - Background Colors
    
    var background: Color {
        colorScheme == .dark
            ? Color(red: 0.05, green: 0.05, blue: 0.1)
            : Color(red: 0.95, green: 0.95, blue: 0.9)
    }
    
    var backgroundSecondary: Color {
        colorScheme == .dark
            ? Color(red: 0.1, green: 0.1, blue: 0.15)
            : Color.white
    }
    
    var fieldBackground: Color {
        colorScheme == .dark
            ? Color(red: 0, green: 0.3, blue: 0)
            : Color(red: 0, green: 0.6, blue: 0)
    }
    
    // MARK: - Text Colors
    
    var textPrimary: Color {
        colorScheme == .dark 
            ? Color(red: 1.0, green: 1.0, blue: 1.0)     // Pure white for maximum contrast
            : Color(red: 0.1, green: 0.1, blue: 0.1)     // Near black for light mode
    }
    
    var textSecondary: Color {
        colorScheme == .dark
            ? Color(red: 0.9, green: 0.9, blue: 0.9)     // Much brighter gray for better visibility
            : Color(red: 0.5, green: 0.5, blue: 0.5)     // Medium gray for light mode
    }
    
    var textInverted: Color {
        colorScheme == .dark ? Color.black : Color.white
    }
    
    // MARK: - Button Colors
    
    var buttonPrimary: Color { primaryCyan }
    var buttonSecondary: Color { primaryRed }
    var buttonTertiary: Color { primaryYellow }
    
    var buttonDisabled: Color {
        colorScheme == .dark
            ? Color(red: 0.3, green: 0.3, blue: 0.3)
            : Color(red: 0.8, green: 0.8, blue: 0.8)
    }
    
    // MARK: - Border Colors
    
    var border: Color {
        colorScheme == .dark
            ? Color(red: 0.3, green: 0.3, blue: 0.3)
            : Color(red: 0.8, green: 0.8, blue: 0.8)
    }
    
    var borderAccent: Color { primaryCyan }
}
