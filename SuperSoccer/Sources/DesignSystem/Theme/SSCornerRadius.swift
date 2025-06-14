//
//  SSCornerRadius.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

/// SuperSoccer corner radius system
/// Provides consistent border radius values throughout the app
struct SSCornerRadius {
    
    // MARK: - Base Corner Radius Values
    
    /// No corner radius - 0pt
    let none: CGFloat = 0
    
    /// Small corner radius - 4pt
    let small: CGFloat = 4
    
    /// Medium corner radius - 8pt
    let medium: CGFloat = 8
    
    /// Large corner radius - 12pt
    let large: CGFloat = 12
    
    /// Extra large corner radius - 16pt
    let extraLarge: CGFloat = 16
    
    /// Circle/pill corner radius - very large value
    let circle: CGFloat = 1000
    
    // MARK: - Component-Specific Corner Radius
    
    /// Corner radius for buttons
    var button: CGFloat { medium }
    
    /// Corner radius for cards
    var card: CGFloat { large }
    
    /// Corner radius for text fields
    var textField: CGFloat { medium }
    
    /// Corner radius for small components (badges, chips)
    var badge: CGFloat { small }
    
    /// Corner radius for modal/sheet presentations
    var modal: CGFloat { extraLarge }
    
    /// Corner radius for images
    var image: CGFloat { medium }
}

// MARK: - Convenience Extensions
extension SSCornerRadius {
    
    /// Get corner radius for specific corners
    func corners(_ corners: UIRectCorner, radius: CGFloat) -> some Shape {
        RoundedCorner(radius: radius, corners: corners)
    }
}

// MARK: - Custom Shape for Specific Corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
