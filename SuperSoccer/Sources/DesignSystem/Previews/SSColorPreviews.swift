//
//  SSColorPreviews.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct SSColorPreviews: View {
    @State private var isDarkMode = false
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Theme Toggle
                    themeToggleSection
                    
                    // Primary Colors (Starbyte-inspired)
                    primaryColorsSection
                    
                    // Background Colors
                    backgroundColorsSection
                    
                    // Text Colors
                    textColorsSection
                    
                    // Button Colors
                    buttonColorsSection
                    
                    // Color Usage Examples
                    colorUsageExamplesSection
                }
                .padding()
            }
            .navigationTitle("Color Palette")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private var themeToggleSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Theme Toggle")
            
            Toggle("Dark Mode", isOn: $isDarkMode)
                .toggleStyle(SwitchToggleStyle())
        }
    }
    
    private var primaryColorsSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Primary Colors (Starbyte-inspired)")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ColorSwatch(
                    name: "Primary Cyan",
                    color: theme.colors.primaryCyan,
                    description: "Main action color"
                )
                
                ColorSwatch(
                    name: "Primary Red",
                    color: theme.colors.primaryRed,
                    description: "Secondary/Alert color"
                )
                
                ColorSwatch(
                    name: "Primary Yellow",
                    color: theme.colors.primaryYellow,
                    description: "Accent/Highlight color"
                )
                
                ColorSwatch(
                    name: "Primary Green",
                    color: theme.colors.primaryGreen,
                    description: "Success/Positive color"
                )
                
                ColorSwatch(
                    name: "Primary Blue",
                    color: theme.colors.primaryBlue,
                    description: "Information/Link color"
                )
                
                ColorSwatch(
                    name: "Primary Magenta",
                    color: theme.colors.primaryMagenta,
                    description: "Special accent color"
                )
            }
        }
    }
    
    private var backgroundColorsSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Background Colors")
            
            VStack(spacing: 12) {
                ColorSwatch(
                    name: "Primary Background",
                    color: theme.colors.background,
                    description: "Main app background"
                )
                
                ColorSwatch(
                    name: "Secondary Background",
                    color: theme.colors.backgroundSecondary,
                    description: "Cards and sections"
                )
                
                ColorSwatch(
                    name: "Field Background",
                    color: theme.colors.fieldBackground,
                    description: "Soccer field/game areas"
                )
            }
        }
    }
    
    private var textColorsSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Text Colors")
            
            VStack(spacing: 12) {
                ColorSwatch(
                    name: "Primary Text",
                    color: theme.colors.textPrimary,
                    description: "Main text color"
                )
                
                ColorSwatch(
                    name: "Secondary Text",
                    color: theme.colors.textSecondary,
                    description: "Supporting text"
                )
                
                ColorSwatch(
                    name: "Inverted Text",
                    color: theme.colors.textInverted,
                    description: "Text on colored backgrounds"
                )
            }
        }
    }
    
    private var buttonColorsSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Button Colors")
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                ColorSwatch(
                    name: "Primary Button",
                    color: theme.colors.buttonPrimary,
                    description: "Main actions"
                )
                
                ColorSwatch(
                    name: "Secondary Button",
                    color: theme.colors.buttonSecondary,
                    description: "Secondary actions"
                )
                
                ColorSwatch(
                    name: "Tertiary Button",
                    color: theme.colors.buttonTertiary,
                    description: "Tertiary actions"
                )
                
                ColorSwatch(
                    name: "Disabled Button",
                    color: theme.colors.buttonDisabled,
                    description: "Disabled state"
                )
            }
        }
    }
    
    private var colorUsageExamplesSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Color Usage Examples")
            
            VStack(spacing: 16) {
                // Game Score Example
                HStack {
                    VStack {
                        SSTitle.title3("Arsenal", color: theme.colors.primaryCyan)
                        SSTitle.largeTitle("2", color: theme.colors.primaryYellow)
                    }
                    
                    SSLabel.headline("-", color: theme.colors.textSecondary)
                    
                    VStack {
                        SSTitle.title3("Chelsea", color: theme.colors.primaryCyan)
                        SSTitle.largeTitle("1", color: theme.colors.primaryYellow)
                    }
                }
                .padding()
                .background(theme.colors.backgroundSecondary)
                .cornerRadius(theme.cornerRadius.card)
                
                // Status Examples
                HStack(spacing: 16) {
                    VStack {
                        SSLabel.caption("Win", color: theme.colors.primaryGreen)
                        SSLabel.caption("Draw", color: theme.colors.primaryYellow)
                        SSLabel.caption("Loss", color: theme.colors.primaryRed)
                    }
                    
                    Spacer()
                    
                    VStack {
                        SSLabel.caption("Injured", color: theme.colors.primaryRed)
                        SSLabel.caption("Available", color: theme.colors.primaryGreen)
                        SSLabel.caption("Suspended", color: theme.colors.primaryMagenta)
                    }
                }
                .padding()
                .background(theme.colors.backgroundSecondary)
                .cornerRadius(theme.cornerRadius.card)
            }
        }
    }
}

struct ColorSwatch: View {
    let name: String
    let color: Color
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Rectangle()
                .fill(color)
                .frame(height: 60)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            
            VStack(spacing: 4) {
                SSLabel.caption(name)
                    .font(.system(size: 12, weight: .semibold))
                
                SSLabel.caption2(description)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    SSThemeProvider {
        SSColorPreviews()
    }
}

#Preview("Dark Mode") {
    SSThemeProvider {
        SSColorPreviews()
            .preferredColorScheme(.dark)
    }
}
