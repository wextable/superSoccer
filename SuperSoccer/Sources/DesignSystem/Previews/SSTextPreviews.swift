//
//  SSTextPreviews.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct SSTextPreviews: View {
    @State private var isDarkMode = false
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Theme Toggle
                    themeToggleSection
                    
                    // Title Components
                    titleSection
                    
                    // Label Components
                    labelSection
                    
                    // Color Variations
                    colorVariationsSection
                    
                    // Typography Hierarchy
                    typographyHierarchySection
                }
                .padding()
            }
            .navigationTitle("Text Components")
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
    
    private var titleSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Title Components")
            
            VStack(alignment: .leading, spacing: 12) {
                SSTitle.largeTitle("Large Title - SuperSoccer")
                SSTitle.title("Title - Team Management")
                SSTitle.title2("Title 2 - Player Stats")
                SSTitle.title3("Title 3 - Match Details")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var labelSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Label Components")
            
            VStack(alignment: .leading, spacing: 12) {
                SSLabel.headline("Headline - Important Information")
                SSLabel.body("Body - This is the standard body text used throughout the app.")
                SSLabel.callout("Callout - Secondary information text")
                SSLabel.subheadline("Subheadline - Supporting text")
                SSLabel.footnote("Footnote - Small details and disclaimers")
                SSLabel.caption("Caption - Image captions and metadata")
                SSLabel.caption2("Caption 2 - Smallest text size")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var colorVariationsSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Color Variations")
            
            VStack(alignment: .leading, spacing: 12) {
                SSTitle.title("Colored Titles")
                
                Group {
                    SSTitle.title("Primary Cyan Title", color: theme.colors.primaryCyan)
                    SSTitle.title("Primary Red Title", color: theme.colors.primaryRed)
                    SSTitle.title("Primary Yellow Title", color: theme.colors.primaryYellow)
                    SSTitle.title("Primary Green Title", color: theme.colors.primaryGreen)
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                SSTitle.title("Colored Labels")
                
                Group {
                    SSLabel.body("Primary Cyan Label", color: theme.colors.primaryCyan)
                    SSLabel.body("Primary Red Label", color: theme.colors.primaryRed)
                    SSLabel.body("Primary Yellow Label", color: theme.colors.primaryYellow)
                    SSLabel.body("Primary Green Label", color: theme.colors.primaryGreen)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var typographyHierarchySection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Typography Hierarchy")
            
            VStack(alignment: .leading, spacing: 16) {
                // Game Screen Example
                VStack(alignment: .leading, spacing: 8) {
                    SSTitle.largeTitle("Match Day")
                    SSTitle.title2("Arsenal vs Chelsea")
                    SSLabel.headline("Premier League - Week 15")
                    SSLabel.body("Kickoff: 3:00 PM")
                    SSLabel.callout("Emirates Stadium, London")
                    SSLabel.footnote("Weather: Sunny, 18°C")
                }
                
                Divider()
                    .padding(.vertical, 8)
                
                // Player Card Example
                VStack(alignment: .leading, spacing: 8) {
                    SSTitle.title3("Player Profile")
                    SSLabel.headline("Marcus Johnson")
                    SSLabel.body("Position: Midfielder")
                    SSLabel.callout("Age: 24 • Height: 5'10\"")
                    SSLabel.footnote("Contract expires: 2026")
                    SSLabel.caption("Last updated: Today")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    SSThemeProvider {
        SSTextPreviews()
    }
}

#Preview("Dark Mode") {
    SSThemeProvider {
        SSTextPreviews()
            .preferredColorScheme(.dark)
    }
}
