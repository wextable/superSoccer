//
//  SSFonts.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

/// SuperSoccer font system
/// Uses SF Mono for headers (retro computer feel) and system fonts for body text
struct SSFonts {
    
    // MARK: - Header Fonts (SF Mono for retro feel)
    
    /// Large title - main screen headers
    var largeTitle: Font {
        .custom("SF Mono", size: 28, relativeTo: .largeTitle)
            .weight(.bold)
    }
    
    /// Title - section headers
    var title: Font {
        .custom("SF Mono", size: 22, relativeTo: .title)
            .weight(.bold)
    }
    
    /// Title 2 - subsection headers
    var title2: Font {
        .custom("SF Mono", size: 20, relativeTo: .title2)
            .weight(.semibold)
    }
    
    /// Title 3 - smaller headers
    var title3: Font {
        .custom("SF Mono", size: 18, relativeTo: .title3)
            .weight(.semibold)
    }
    
    // MARK: - Body Fonts (System fonts for readability)
    
    /// Headline - important body text
    var headline: Font {
        .system(size: 17, weight: .semibold, design: .default)
    }
    
    /// Body - standard body text
    var body: Font {
        .system(size: 17, weight: .regular, design: .default)
    }
    
    /// Callout - secondary body text
    var callout: Font {
        .system(size: 16, weight: .regular, design: .default)
    }
    
    /// Subheadline - smaller body text
    var subheadline: Font {
        .system(size: 15, weight: .regular, design: .default)
    }
    
    /// Footnote - small text
    var footnote: Font {
        .system(size: 13, weight: .regular, design: .default)
    }
    
    /// Caption - very small text
    var caption: Font {
        .system(size: 12, weight: .regular, design: .default)
    }
    
    /// Caption 2 - smallest text
    var caption2: Font {
        .system(size: 11, weight: .regular, design: .default)
    }
    
    // MARK: - Button Fonts
    
    /// Primary button text
    var buttonPrimary: Font {
        .system(size: 17, weight: .semibold, design: .default)
    }
    
    /// Secondary button text
    var buttonSecondary: Font {
        .system(size: 15, weight: .medium, design: .default)
    }
    
    /// Small button text
    var buttonSmall: Font {
        .system(size: 13, weight: .medium, design: .default)
    }
    
    // MARK: - Special Fonts
    
    /// Monospace font for scores, stats, and data
    var monospace: Font {
        .custom("SF Mono", size: 16, relativeTo: .body)
            .weight(.medium)
    }
    
    /// Large monospace for big numbers (scores, etc.)
    var monospaceLarge: Font {
        .custom("SF Mono", size: 24, relativeTo: .title)
            .weight(.bold)
    }
}

// MARK: - Font Weight Extensions
extension SSFonts {
    
    /// Get a font with specific weight
    func font(_ baseFont: Font, weight: Font.Weight) -> Font {
        // Note: This is a simplified approach. In a real implementation,
        // you might want to create specific font variants for each weight.
        return baseFont.weight(weight)
    }
}

// MARK: - Fallback Fonts
extension SSFonts {
    
    /// Fallback fonts when SF Mono is not available
    private var fallbackMonospace: Font {
        .system(.body, design: .monospaced)
    }
    
    /// Get monospace font with fallback
    var safeMonospace: Font {
        if UIFont(name: "SF Mono", size: 16) != nil {
            return monospace
        } else {
            return fallbackMonospace
        }
    }
}
