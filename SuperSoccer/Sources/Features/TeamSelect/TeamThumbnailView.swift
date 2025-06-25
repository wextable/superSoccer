//
//  TeamThumbnailView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import SwiftUI

struct TeamThumbnailViewModel: Identifiable {
    let id: String
    let text: String
}

struct TeamThumbnailView: View {
    let viewModel: TeamThumbnailViewModel
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        HStack {
            SSTitle.title2(viewModel.text)
            Spacer()
        }
        .padding(.vertical, theme.spacing.medium)
        .contentShape(Rectangle())
    }
}

#Preview {
    TeamThumbnailView(viewModel: .make())
}

#if DEBUG
extension TeamThumbnailViewModel {
    static func make(
        id: String = "1",
        text: String = "Auburn Tigers"
    ) -> Self {
        self.init(
            id: id,
            text: text
        )
    }
}
#endif
