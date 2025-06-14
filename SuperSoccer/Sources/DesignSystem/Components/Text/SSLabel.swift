//
//  SSLabel.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

// MARK: - Label Style Enum
enum SSLabelStyle {
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption
    case caption2
}

// MARK: - ViewModel
struct SSLabelViewModel {
    let text: String
    let style: SSLabelStyle
    let color: Color?
    
    init(text: String, style: SSLabelStyle = .body, color: Color? = nil) {
        self.text = text
        self.style = style
        self.color = color
    }
}

// MARK: - Component
struct SSLabel: View {
    let viewModel: SSLabelViewModel
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        Text(viewModel.text)
            .font(fontForStyle(viewModel.style))
            .foregroundColor(viewModel.color ?? colorForStyle(viewModel.style))
    }
    
    private func fontForStyle(_ style: SSLabelStyle) -> Font {
        switch style {
        case .headline:
            return theme.fonts.headline
        case .body:
            return theme.fonts.body
        case .callout:
            return theme.fonts.callout
        case .subheadline:
            return theme.fonts.subheadline
        case .footnote:
            return theme.fonts.footnote
        case .caption:
            return theme.fonts.caption
        case .caption2:
            return theme.fonts.caption2
        }
    }
    
    private func colorForStyle(_ style: SSLabelStyle) -> Color {
        switch style {
        case .headline, .body:
            return theme.colors.textPrimary
        case .callout, .subheadline, .footnote, .caption, .caption2:
            return theme.colors.textSecondary
        }
    }
}

// MARK: - Factory Methods
extension SSLabel {
    static func headline(
        _ text: String,
        color: Color? = nil
    ) -> SSLabel {
        SSLabel(
            viewModel: SSLabelViewModel(
                text: text,
                style: .headline,
                color: color
            )
        )
    }
    
    static func body(
        _ text: String,
        color: Color? = nil
    ) -> SSLabel {
        SSLabel(
            viewModel: SSLabelViewModel(
                text: text,
                style: .body,
                color: color
            )
        )
    }
    
    static func callout(
        _ text: String,
        color: Color? = nil
    ) -> SSLabel {
        SSLabel(
            viewModel: SSLabelViewModel(
                text: text,
                style: .callout,
                color: color
            )
        )
    }
    
    static func subheadline(
        _ text: String,
        color: Color? = nil
    ) -> SSLabel {
        SSLabel(
            viewModel: SSLabelViewModel(
                text: text,
                style: .subheadline,
                color: color
            )
        )
    }
    
    static func footnote(
        _ text: String,
        color: Color? = nil
    ) -> SSLabel {
        SSLabel(
            viewModel: SSLabelViewModel(
                text: text,
                style: .footnote,
                color: color
            )
        )
    }
    
    static func caption(
        _ text: String,
        color: Color? = nil
    ) -> SSLabel {
        SSLabel(
            viewModel: SSLabelViewModel(
                text: text,
                style: .caption,
                color: color
            )
        )
    }
    
    static func caption2(
        _ text: String,
        color: Color? = nil
    ) -> SSLabel {
        SSLabel(
            viewModel: SSLabelViewModel(
                text: text,
                style: .caption2,
                color: color
            )
        )
    }
}

// MARK: - Debug Extensions
#if DEBUG
extension SSLabelViewModel {
    static func make(
        text: String = "Sample Label",
        style: SSLabelStyle = .body,
        color: Color? = nil
    ) -> Self {
        self.init(
            text: text,
            style: style,
            color: color
        )
    }
}
#endif
