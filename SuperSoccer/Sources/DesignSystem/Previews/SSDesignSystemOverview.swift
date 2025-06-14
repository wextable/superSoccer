//
//  SSDesignSystemOverview.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct SSDesignSystemOverview: View {
    @State private var isDarkMode = false
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Header
                    headerSection
                    
                    // Theme Toggle
                    themeToggleSection
                    
                    // Quick Component Showcase
                    componentShowcaseSection
                    
                    // Navigation Links
                    navigationLinksSection
                    
                    // Design Principles
                    designPrinciplesSection
                    
                    // Usage Guidelines
                    usageGuidelinesSection
                }
                .padding()
            }
            .navigationTitle("Design System")
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 16) {
            SSTitle.largeTitle("SuperSoccer Design System")
            SSLabel.headline("Retro-inspired UI framework for consistent, beautiful interfaces")
            
            VStack(spacing: 8) {
                SSLabel.callout("Inspired by Starbyte Super Soccer (1991)")
                SSLabel.footnote("Modern SwiftUI implementation with light/dark mode support")
            }
        }
    }
    
    private var themeToggleSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Theme Toggle")
            
            Toggle("Dark Mode", isOn: $isDarkMode)
                .toggleStyle(SwitchToggleStyle())
        }
    }
    
    private var componentShowcaseSection: some View {
        VStack(spacing: 24) {
            SSTitle.title2("Component Showcase")
            
            // Buttons
            VStack(spacing: 12) {
                SSTitle.title3("Buttons")
                
                HStack(spacing: 12) {
                    SSPrimaryButton.make(
                        title: "Primary",
                        action: { print("Primary tapped") }
                    )
                    
                    SSSecondaryButton.make(
                        title: "Secondary",
                        action: { print("Secondary tapped") }
                    )
                }
                
                HStack(spacing: 24) {
                    SSTextButton.make(
                        title: "Text Button",
                        action: { print("Text tapped") }
                    )
                    
                    SSTextButton.make(
                        title: "Disabled",
                        isEnabled: false,
                        action: { }
                    )
                }
            }
            
            // Typography
            VStack(spacing: 12) {
                SSTitle.title3("Typography")
                
                VStack(alignment: .leading, spacing: 8) {
                    SSTitle.title("Title - SF Mono Bold")
                    SSLabel.headline("Headline - System Semibold")
                    SSLabel.body("Body - System Regular")
                    SSLabel.callout("Callout - System Regular")
                    SSLabel.footnote("Footnote - System Regular")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            // Colors
            VStack(spacing: 12) {
                SSTitle.title3("Color Palette")
                
            HStack(spacing: 8) {
                ColorDot(color: theme.colors.primaryCyan, name: "Cyan")
                ColorDot(color: theme.colors.primaryRed, name: "Red")
                ColorDot(color: theme.colors.primaryYellow, name: "Yellow")
                ColorDot(color: theme.colors.primaryGreen, name: "Green")
                ColorDot(color: theme.colors.primaryBlue, name: "Blue")
                ColorDot(color: theme.colors.primaryMagenta, name: "Magenta")
            }
            }
        }
    }
    
    private var navigationLinksSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Explore Components")
            
            VStack(spacing: 12) {
                NavigationLink(destination: SSButtonPreviews()) {
                    ComponentNavigationCard(
                        title: "Buttons",
                        description: "Primary, Secondary, and Text buttons",
                        icon: "button.programmable"
                    )
                }
                
                NavigationLink(destination: SSTextPreviews()) {
                    ComponentNavigationCard(
                        title: "Typography",
                        description: "Titles, Labels, and text hierarchy",
                        icon: "textformat"
                    )
                }
                
                NavigationLink(destination: SSColorPreviews()) {
                    ComponentNavigationCard(
                        title: "Colors",
                        description: "Retro-inspired color palette",
                        icon: "paintpalette"
                    )
                }
            }
        }
    }
    
    private var designPrinciplesSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Design Principles")
            
            VStack(spacing: 12) {
                DesignPrincipleCard(
                    title: "Retro Aesthetic",
                    description: "Bright, bold colors inspired by classic 90s soccer games"
                )
                
                DesignPrincipleCard(
                    title: "Consistent Spacing",
                    description: "8pt grid system for predictable layouts"
                )
                
                DesignPrincipleCard(
                    title: "Accessible Typography",
                    description: "SF Mono for headers, system fonts for readability"
                )
                
                DesignPrincipleCard(
                    title: "Dark Mode Support",
                    description: "Adaptive colors that work in both light and dark themes"
                )
            }
        }
    }
    
    private var usageGuidelinesSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Usage Guidelines")
            
            VStack(alignment: .leading, spacing: 12) {
                UsageGuideline(
                    title: "Theme Access",
                    code: "@Environment(\\.ssTheme) private var theme"
                )
                
                UsageGuideline(
                    title: "Button Creation",
                    code: "SSPrimaryButton.make(title: \"Action\") { /* action */ }"
                )
                
                UsageGuideline(
                    title: "Text Components",
                    code: "SSTitle.title(\"Header\")\nSSLabel.body(\"Content\")"
                )
                
                UsageGuideline(
                    title: "Color Usage",
                    code: "theme.colors.primaryCyan\ntheme.colors.textPrimary"
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct ColorDot: View {
    let color: Color
    let name: String
    
    var body: some View {
        VStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 24, height: 24)
            
            SSLabel.caption2(name)
        }
    }
}

struct ComponentNavigationCard: View {
    let title: String
    let description: String
    let icon: String
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(theme.colors.primaryCyan)
                .frame(width: 32)
            
            VStack(alignment: .leading, spacing: 4) {
                SSTitle.title3(title)
                SSLabel.callout(description)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(theme.colors.textSecondary)
        }
        .padding()
        .background(theme.colors.backgroundSecondary)
        .cornerRadius(theme.cornerRadius.card)
    }
}

struct DesignPrincipleCard: View {
    let title: String
    let description: String
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SSTitle.title3(title)
            SSLabel.callout(description)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(theme.colors.backgroundSecondary)
        .cornerRadius(theme.cornerRadius.card)
    }
}

struct UsageGuideline: View {
    let title: String
    let code: String
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SSLabel.headline(title)
            
            Text(code)
                .font(theme.fonts.monospace)
                .foregroundColor(theme.colors.primaryCyan)
                .padding(theme.spacing.small)
                .background(theme.colors.backgroundSecondary)
                .cornerRadius(theme.cornerRadius.small)
        }
    }
}

#Preview {
    SSThemeProvider {
        SSDesignSystemOverview()
    }
}

#Preview("Dark Mode") {
    SSThemeProvider {
        SSDesignSystemOverview()
            .preferredColorScheme(.dark)
    }
}
