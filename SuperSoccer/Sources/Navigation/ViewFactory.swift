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
        case .mainMenu(let interactor):
            return AnyView(SSThemeProvider { MainMenuView(interactor: interactor) })
        case .newGame(let interactor):
            return AnyView(SSThemeProvider{ NewGameView(interactor: interactor) })
        case .teamSelect(let interactor):
            return AnyView(
                NavigationStack {
                    SSThemeProvider {
                        TeamSelectView(interactor: interactor)
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

#if DEBUG
class MockViewFactory: ViewFactoryProtocol {
    var screensMade: [NavigationRouter.Screen] = []
    
    func makeView(for screen: NavigationRouter.Screen) -> AnyView {
        screensMade.append(screen)
        switch screen {
        case .splash:
            return AnyView(SplashView())
        case .mainMenu(let interactor):
            return AnyView(SSThemeProvider { MainMenuView(interactor: interactor) })
        case .newGame(let interactor):
            return AnyView(SSThemeProvider{ NewGameView(interactor: interactor) })
        case .teamSelect(let interactor):
            return AnyView(
                NavigationStack {
                    SSThemeProvider {
                        TeamSelectView(interactor: interactor)
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
