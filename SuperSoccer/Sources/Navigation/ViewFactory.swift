//
//  ViewFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

import SwiftUI

@MainActor
protocol ViewFactoryProtocol {
    func makeView(for screen: NavigationRouter.Screen) -> AnyView
}

final class ViewFactory: ViewFactoryProtocol {
    func makeView(for screen: NavigationRouter.Screen) -> AnyView {
        switch screen {
        case .splash:
            return AnyView(SplashView())
        case .mainMenu(let presenter):
            return AnyView(SSThemeProvider { MainMenuView(presenter: presenter) })
        case .newGame(let presenter):
            return AnyView(SSThemeProvider{ NewGameView(presenter: presenter) })
        case .teamSelect(let presenter):
            return AnyView(
                SSThemeProvider {
                    NavigationStack {
                        TeamSelectView(presenter: presenter)
                    }
                }
            )
        case .team(let interactor):
            return AnyView(SSThemeProvider { TeamView(interactor: interactor) })
        case .tabContainer(let tabs):
            return AnyView(TabContainerView.make(tabs: tabs, viewFactory: self))
        }
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
class MockViewFactory: ViewFactoryProtocol {
    var screensMade: [NavigationRouter.Screen] = []
    
    func makeView(for screen: NavigationRouter.Screen) -> AnyView {
        screensMade.append(screen)
        switch screen {
        case .splash:
            return AnyView(SplashView())
        case .mainMenu(let presenter):
            return AnyView(SSThemeProvider { MainMenuView(presenter: presenter) })
        case .newGame(let presenter):
            return AnyView(SSThemeProvider{ NewGameView(presenter: presenter) })
        case .teamSelect(let presenter):
            return AnyView(
                NavigationStack {
                    SSThemeProvider {
                        TeamSelectView(presenter: presenter)
                    }
                }
            )
        case .team(let interactor):
            return AnyView(SSThemeProvider { TeamView(interactor: interactor) })
        case .tabContainer(let tabs):
            return AnyView(TabContainerView.make(tabs: tabs, viewFactory: self))
        }
    }
}
#endif
