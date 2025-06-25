//
//  SSButtonPreviews.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct SSButtonPreviews: View {
    @State private var isDarkMode = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    // Theme Toggle
                    themeToggleSection
                    
                    // Primary Buttons
                    primaryButtonSection
                    
                    // Secondary Buttons
                    secondaryButtonSection
                    
                    // Text Buttons
                    textButtonSection
                    
                    // Button States
                    buttonStatesSection
                }
                .padding()
            }
            .navigationTitle("Button Components")
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
    
    private var primaryButtonSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Primary Buttons")
            
            SSPrimaryButton.make(
                title: "New game",
                action: { print("New Game tapped") }
            )
            
            SSPrimaryButton.make(
                title: "Continue Career",
                action: { print("Continue Career tapped") }
            )
            
            SSPrimaryButton.make(
                title: "Start Match",
                action: { print("Start Match tapped") }
            )
        }
    }
    
    private var secondaryButtonSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Secondary Buttons")
            
            SSSecondaryButton.make(
                title: "Cancel",
                action: { print("Cancel tapped") }
            )
            
            SSSecondaryButton.make(
                title: "Delete Career",
                action: { print("Delete Career tapped") }
            )
            
            SSSecondaryButton.make(
                title: "Reset Settings",
                action: { print("Reset Settings tapped") }
            )
        }
    }
    
    private var textButtonSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Text Buttons")
            
            HStack(spacing: 24) {
                SSTextButton.make(
                    title: "Skip",
                    action: { print("Skip tapped") }
                )
                
                SSTextButton.make(
                    title: "Learn More",
                    action: { print("Learn More tapped") }
                )
                
                SSTextButton.make(
                    title: "Help",
                    action: { print("Help tapped") }
                )
            }
        }
    }
    
    private var buttonStatesSection: some View {
        VStack(spacing: 16) {
            SSTitle.title2("Button States")
            
            VStack(spacing: 12) {
                SSLabel.caption("Enabled vs Disabled")
                
                SSPrimaryButton.make(
                    title: "Enabled Button",
                    isEnabled: true,
                    action: { print("Enabled button tapped") }
                )
                
                SSPrimaryButton.make(
                    title: "Disabled Button",
                    isEnabled: false,
                    action: { print("This won't be called") }
                )
                
                SSSecondaryButton.make(
                    title: "Enabled Secondary",
                    isEnabled: true,
                    action: { print("Enabled secondary tapped") }
                )
                
                SSSecondaryButton.make(
                    title: "Disabled Secondary",
                    isEnabled: false,
                    action: { print("This won't be called") }
                )
                
                HStack(spacing: 24) {
                    SSTextButton.make(
                        title: "Enabled Text",
                        isEnabled: true,
                        action: { print("Enabled text tapped") }
                    )
                    
                    SSTextButton.make(
                        title: "Disabled Text",
                        isEnabled: false,
                        action: { print("This won't be called") }
                    )
                }
            }
        }
    }
}

#Preview {
    SSThemeProvider {
        SSButtonPreviews()
    }
}

#Preview("Dark Mode") {
    SSThemeProvider {
        SSButtonPreviews()
            .preferredColorScheme(.dark)
    }
}
