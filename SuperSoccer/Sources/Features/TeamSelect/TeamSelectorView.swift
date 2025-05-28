//
//  TeamSelectorView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/26/25.
//

import SwiftUI

struct TeamSelectorViewModel {
    let title: String
    let buttonTitle: String
    let action: (() -> Void)
}

struct TeamSelectorView: View {
    var viewModel: TeamSelectorViewModel
    
    var body: some View {
        HStack {
            Text(viewModel.title)
                .font(.headline)
            Button(action: {
                viewModel.action()
            }) {
                Text(viewModel.buttonTitle)
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
        }
    }
}

#if DEBUG
extension TeamSelectorViewModel {
    static func make(
        title: String = "Team:",
        buttonTitle: String = "Select Your Team",
        action: @escaping () -> Void = {}
    ) -> Self {
        self.init(
            title: title,
            buttonTitle: buttonTitle,
            action: action
        )
    }
}
#endif
