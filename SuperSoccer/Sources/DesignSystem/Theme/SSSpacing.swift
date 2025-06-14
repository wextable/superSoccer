//
//  SSSpacing.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

/// SuperSoccer spacing system
/// Provides consistent spacing values throughout the app
struct SSSpacing {
    
    // MARK: - Base Spacing Values
    
    /// Extra small spacing - 4pt
    let extraSmall: CGFloat = 4
    
    /// Small spacing - 8pt
    let small: CGFloat = 8
    
    /// Medium spacing - 16pt
    let medium: CGFloat = 16
    
    /// Large spacing - 24pt
    let large: CGFloat = 24
    
    /// Extra large spacing - 32pt
    let extraLarge: CGFloat = 32
    
    /// Extra extra large spacing - 48pt
    let extraExtraLarge: CGFloat = 48
    
    // MARK: - Semantic Spacing
    
    /// Padding inside buttons
    var buttonPadding: EdgeInsets {
        EdgeInsets(top: small, leading: medium, bottom: small, trailing: medium)
    }
    
    /// Padding inside cards
    var cardPadding: EdgeInsets {
        EdgeInsets(top: medium, leading: medium, bottom: medium, trailing: medium)
    }
    
    /// Padding for screen edges
    var screenPadding: EdgeInsets {
        EdgeInsets(top: medium, leading: medium, bottom: medium, trailing: medium)
    }
    
    /// Spacing between sections
    var sectionSpacing: CGFloat { large }
    
    /// Spacing between list items
    var listItemSpacing: CGFloat { small }
    
    /// Spacing between form elements
    var formSpacing: CGFloat { medium }
    
    // MARK: - Component-Specific Spacing
    
    /// Spacing between button and text in a button
    var buttonTextSpacing: CGFloat { small }
    
    /// Spacing between icon and text
    var iconTextSpacing: CGFloat { small }
    
    /// Spacing between title and content
    var titleContentSpacing: CGFloat { medium }
    
    /// Spacing for navigation bar elements
    var navigationSpacing: CGFloat { medium }
}

// MARK: - Convenience Extensions
extension SSSpacing {
    
    /// Get horizontal padding
    func horizontalPadding(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: 0, leading: value, bottom: 0, trailing: value)
    }
    
    /// Get vertical padding
    func verticalPadding(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: 0, bottom: value, trailing: 0)
    }
    
    /// Get uniform padding
    func uniformPadding(_ value: CGFloat) -> EdgeInsets {
        EdgeInsets(top: value, leading: value, bottom: value, trailing: value)
    }
}
