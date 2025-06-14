# SuperSoccer Design System

A comprehensive, retro-inspired design system for the SuperSoccer app, built with SwiftUI and inspired by the classic Starbyte Super Soccer (1991).

## Overview

The SuperSoccer Design System provides a consistent, beautiful, and accessible UI framework that captures the nostalgic feel of classic 90s soccer games while maintaining modern usability standards.

## Features

- 🎨 **Retro Color Palette**: Bright, bold colors inspired by classic arcade games
- 🌓 **Dark Mode Support**: Adaptive colors that work beautifully in both light and dark themes
- 📱 **SwiftUI Native**: Built specifically for SwiftUI with environment-based theming
- 🔧 **Component-Based**: Reusable components with consistent APIs
- 📏 **8pt Grid System**: Consistent spacing throughout the app
- 🎯 **Accessibility**: Readable typography and proper contrast ratios

## Architecture

### Theme System

The design system is built around a central `SSTheme` that provides access to all design tokens:

```swift
@Environment(\.ssTheme) private var theme
```

### Core Components

- **Colors**: `SSColors` - Retro-inspired color palette
- **Typography**: `SSFonts` - SF Mono headers + system fonts for body text
- **Spacing**: `SSSpacing` - 8pt grid system
- **Corner Radius**: `SSCornerRadius` - Consistent border radius values

## Quick Start

### 1. Apply Theme to Your App

```swift
// In your main app or root view
ContentView()
    .ssThemed()
```

### 2. Use Components

```swift
// Buttons
SSPrimaryButton.make(title: "Start Game") {
    // Action
}

SSSecondaryButton.make(title: "Cancel") {
    // Action
}

SSTextButton.make(title: "Learn More") {
    // Action
}

// Typography
SSTitle.largeTitle("SuperSoccer")
SSTitle.title("Team Management")
SSLabel.body("Player statistics and information")
SSLabel.caption("Last updated: Today")
```

### 3. Access Theme Values

```swift
struct MyView: View {
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        Text("Hello")
            .foregroundColor(theme.colors.primaryCyan)
            .font(theme.fonts.headline)
            .padding(theme.spacing.medium)
    }
}
```

## Components

### Buttons

#### SSPrimaryButton
Primary action button with cyan background.

```swift
SSPrimaryButton.make(
    title: "New Game",
    isEnabled: true,
    action: { /* action */ }
)
```

#### SSSecondaryButton
Secondary action button with red background.

```swift
SSSecondaryButton.make(
    title: "Delete",
    isEnabled: true,
    action: { /* action */ }
)
```

#### SSTextButton
Text-only button for subtle actions.

```swift
SSTextButton.make(
    title: "Skip",
    isEnabled: true,
    action: { /* action */ }
)
```

### Typography

#### SSTitle
Headers using SF Mono for retro computer feel.

```swift
SSTitle.largeTitle("Main Header")
SSTitle.title("Section Header")
SSTitle.title2("Subsection Header")
SSTitle.title3("Small Header")
```

#### SSLabel
Body text using system fonts for readability.

```swift
SSLabel.headline("Important text")
SSLabel.body("Standard body text")
SSLabel.callout("Secondary information")
SSLabel.subheadline("Supporting text")
SSLabel.footnote("Small details")
SSLabel.caption("Metadata")
SSLabel.caption2("Smallest text")
```

## Color Palette

### Primary Colors (Starbyte-inspired)

- **Primary Cyan** (`primaryCyan`): Main action color
- **Primary Red** (`primaryRed`): Secondary/alert color
- **Primary Yellow** (`primaryYellow`): Accent/highlight color
- **Primary Green** (`primaryGreen`): Success/positive color
- **Primary Blue** (`primaryBlue`): Information/link color
- **Primary Magenta** (`primaryMagenta`): Special accent color

### Background Colors

- **Background** (`background`): Main app background
- **Background Secondary** (`backgroundSecondary`): Cards and sections
- **Field Background** (`fieldBackground`): Soccer field/game areas

### Text Colors

- **Text Primary** (`textPrimary`): Main text color
- **Text Secondary** (`textSecondary`): Supporting text
- **Text Inverted** (`textInverted`): Text on colored backgrounds

### Usage Examples

```swift
// Status indicators
SSLabel.body("Win", color: theme.colors.primaryGreen)
SSLabel.body("Loss", color: theme.colors.primaryRed)
SSLabel.body("Draw", color: theme.colors.primaryYellow)

// Player status
SSLabel.caption("Injured", color: theme.colors.primaryRed)
SSLabel.caption("Available", color: theme.colors.primaryGreen)
```

## Spacing System

Based on an 8pt grid system:

- **Extra Small**: 4pt
- **Small**: 8pt
- **Medium**: 16pt
- **Large**: 24pt
- **Extra Large**: 32pt
- **Extra Extra Large**: 48pt

### Semantic Spacing

```swift
theme.spacing.buttonPadding      // Button internal padding
theme.spacing.cardPadding        // Card internal padding
theme.spacing.screenPadding      // Screen edge padding
theme.spacing.sectionSpacing     // Between sections
theme.spacing.listItemSpacing    // Between list items
```

## Typography System

### Font Hierarchy

- **Headers**: SF Mono (retro computer feel)
  - Large Title: 28pt Bold
  - Title: 22pt Bold
  - Title 2: 20pt Semibold
  - Title 3: 18pt Semibold

- **Body Text**: System fonts (readability)
  - Headline: 17pt Semibold
  - Body: 17pt Regular
  - Callout: 16pt Regular
  - Subheadline: 15pt Regular
  - Footnote: 13pt Regular
  - Caption: 12pt Regular
  - Caption 2: 11pt Regular

### Special Fonts

- **Monospace**: For scores, stats, and data
- **Monospace Large**: For big numbers and scores

## Corner Radius

Consistent border radius values:

- **None**: 0pt
- **Small**: 4pt
- **Medium**: 8pt
- **Large**: 12pt
- **Extra Large**: 16pt
- **Circle**: 1000pt (for circular elements)

### Component-Specific

```swift
theme.cornerRadius.button        // 8pt
theme.cornerRadius.card          // 12pt
theme.cornerRadius.textField     // 8pt
theme.cornerRadius.badge         // 4pt
theme.cornerRadius.modal         // 16pt
```

## Design Principles

### 1. Retro Aesthetic
Bright, bold colors that evoke the classic 90s arcade soccer game experience while remaining modern and accessible.

### 2. Consistent Spacing
Everything follows an 8pt grid system for predictable, harmonious layouts.

### 3. Accessible Typography
SF Mono for headers provides character and nostalgia, while system fonts ensure body text remains highly readable.

### 4. Dark Mode Support
All colors are adaptive and provide appropriate contrast in both light and dark themes.

### 5. Component-Based Architecture
Reusable components with consistent APIs make it easy to build new features quickly.

## Previews

The design system includes comprehensive preview files for development and documentation:

- **SSDesignSystemOverview**: Complete overview with navigation
- **SSButtonPreviews**: All button components and states
- **SSTextPreviews**: Typography hierarchy and examples
- **SSColorPreviews**: Complete color palette with usage examples

### Viewing Previews

1. Open any preview file in Xcode
2. Use the Canvas to see live previews
3. Toggle between light and dark mode
4. Interact with components to test functionality

## Best Practices

### Theme Access
Always access theme through the environment:

```swift
@Environment(\.ssTheme) private var theme
```

### Component Creation
Use factory methods for consistent component creation:

```swift
// ✅ Good
SSPrimaryButton.make(title: "Action") { /* action */ }

// ❌ Avoid
SSPrimaryButton(viewModel: SSPrimaryButtonViewModel(...))
```

### Color Usage
Use semantic color names rather than specific colors:

```swift
// ✅ Good
.foregroundColor(theme.colors.textPrimary)

// ❌ Avoid
.foregroundColor(.black)
```

### Spacing
Use theme spacing values for consistency:

```swift
// ✅ Good
.padding(theme.spacing.medium)

// ❌ Avoid
.padding(16)
```

## Extending the Design System

### Adding New Components

1. Create component in appropriate folder (`Components/`)
2. Follow the ViewModel pattern
3. Provide factory methods
4. Include debug extensions
5. Add to preview files
6. Update this README

### Adding New Colors

1. Add to `SSColors.swift`
2. Ensure light/dark mode support
3. Add to color previews
4. Document usage guidelines

### Adding New Typography

1. Add to `SSFonts.swift`
2. Consider accessibility
3. Add to text previews
4. Update typography hierarchy

## File Structure

```
DesignSystem/
├── README.md                           # This file
├── Theme/
│   ├── SSTheme.swift                   # Main theme container
│   ├── SSColors.swift                  # Color palette
│   ├── SSFonts.swift                   # Typography system
│   ├── SSSpacing.swift                 # Spacing system
│   └── SSCornerRadius.swift            # Corner radius system
├── Components/
│   ├── Buttons/
│   │   ├── SSPrimaryButton.swift       # Primary action button
│   │   ├── SSSecondaryButton.swift     # Secondary action button
│   │   └── SSTextButton.swift          # Text-only button
│   └── Text/
│       ├── SSTitle.swift               # Header components
│       └── SSLabel.swift               # Body text components
└── Previews/
    ├── SSDesignSystemOverview.swift    # Complete overview
    ├── SSButtonPreviews.swift          # Button previews
    ├── SSTextPreviews.swift            # Typography previews
    └── SSColorPreviews.swift           # Color palette previews
```

## Contributing

When contributing to the design system:

1. Follow existing patterns and conventions
2. Ensure accessibility compliance
3. Test in both light and dark modes
4. Update previews and documentation
5. Consider backward compatibility

## Version History

- **v1.0.0**: Initial design system implementation
  - Core theme system
  - Button components
  - Typography components
  - Color palette
  - Spacing system
  - Comprehensive previews
