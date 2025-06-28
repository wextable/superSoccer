//
//  MainMenuView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import SwiftUI

protocol MainMenuViewPresenter: AnyObject {
    var viewModel: MainMenuViewModel { get }
    func newGameTapped()
}

struct MenuItemViewModel: Identifiable {
    var id: String { title }
    let title: String
    let action: () -> Void
}

struct MenuItemView: View {
    let viewModel: MenuItemViewModel
    
    var body: some View {
        Button(action: {
            viewModel.action()
        }) {
            Text(viewModel.title)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }
}

struct MainMenuViewModel {
    let title: String
    let menuItemModels: [MenuItemViewModel]
}

struct MainMenuView: View {
    let presenter: MainMenuViewPresenter  // Changed from MainMenuInteractorProtocol
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.large) {
            ForEach(presenter.viewModel.menuItemModels) { menuItemModel in
                SSPrimaryButton.make(title: menuItemModel.title, action: menuItemModel.action)
            }
            Spacer()
        }
        .padding(theme.spacing.large)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
        .navigationTitle(presenter.viewModel.title)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension MainMenuViewModel {
    static func make(
        title: String = "Main Menu"
    ) -> Self {
        self.init(
            title: title,
            menuItemModels: [
                .init(title: "New game") {}
            ]
        )
    }
}
#endif
