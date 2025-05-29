//
//  MainMenuView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import SwiftUI

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

struct MainMenuView<Interactor: MainMenuInteractorProtocol>: View {
    let interactor: Interactor
    
    var body: some View {
        List(interactor.viewModel.menuItemModels) { menuItemModel in
            MenuItemView(viewModel: menuItemModel)
//            {
//                interactor.eventBus.send(.newGameSelected) // TODO: fix me
//            }
        }
        .navigationTitle(interactor.viewModel.title)
    }
}

#if DEBUG
extension MainMenuViewModel {
    static func make(
        title: String = "Main Menu"
    ) -> Self {
        self.init(
            title: title,
            menuItemModels: [
                .init(title: "New Game") {}
            ]
        )
    }
}
#endif
