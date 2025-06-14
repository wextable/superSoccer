//
//  SSTitle.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

// MARK: - Title Style Enum
enum SSTitleStyle {
    case largeTitle
    case title
    case title2
    case title3
}

// MARK: - ViewModel
struct SSTitleViewModel {
    let text: String
    let style: SSTitleStyle
    let color: Color?
    
    init(text: String, style: SSTitleStyle = .title, color: Color? = nil) {
        self.text = text
        self.style = style
        self.color = color
    }
}

// MARK: - Component
struct SSTitle: View {
    let viewModel: SSTitleViewModel
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        Text(viewModel.text)
            .font(fontForStyle(viewModel.style))
            .foregroundColor(viewModel.color ?? theme.colors.textPrimary)
    }
    
    private func fontForStyle(_ style: SSTitleStyle) -> Font {
        switch style {
        case .largeTitle:
            return theme.fonts.largeTitle
        case .title:
            return theme.fonts.title
        case .title2:
            return theme.fonts.title2
        case .title3:
            return theme.fonts.title3
        }
    }
}

// MARK: - Factory Methods
extension SSTitle {
    static func largeTitle(
        _ text: String,
        color: Color? = nil
    ) -> SSTitle {
        SSTitle(
            viewModel: SSTitleViewModel(
                text: text,
                style: .largeTitle,
                color: color
            )
        )
    }
    
    static func title(
        _ text: String,
        color: Color? = nil
    ) -> SSTitle {
        SSTitle(
            viewModel: SSTitleViewModel(
                text: text,
                style: .title,
                color: color
            )
        )
    }
    
    static func title2(
        _ text: String,
        color: Color? = nil
    ) -> SSTitle {
        SSTitle(
            viewModel: SSTitleViewModel(
                text: text,
                style: .title2,
                color: color
            )
        )
    }
    
    static func title3(
        _ text: String,
        color: Color? = nil
    ) -> SSTitle {
        SSTitle(
            viewModel: SSTitleViewModel(
                text: text,
                style: .title3,
                color: color
            )
        )
    }
}

// MARK: - Debug Extensions
#if DEBUG
extension SSTitleViewModel {
    static func make(
        text: String = "Sample Title",
        style: SSTitleStyle = .title,
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
