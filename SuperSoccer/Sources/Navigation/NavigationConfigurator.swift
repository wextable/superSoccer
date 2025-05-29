//
//  NavigationConfigurator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import SwiftUI

struct NavigationConfigurator: ViewModifier {
    @ObservedObject var router: NavigationRouter
    private let viewFactory: ViewFactoryProtocol
    
    init(viewFactory: ViewFactoryProtocol, router: NavigationRouter) {
        self.viewFactory = viewFactory
        self.router = router
    }
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: NavigationRouter.Screen.self) { screen in
                makeDestinationView(for: screen)
                    .id(screen.id) // Force unique identity for each screen
            }
            .sheet(item: $router.presentedSheet) { screen in
                makeDestinationView(for: screen)
                    .id(screen.id)
            }
            .environmentObject(router)
    }
    
    @ViewBuilder
    private func makeDestinationView(for screen: NavigationRouter.Screen) -> some View {
        switch screen {
        case .splash:
            viewFactory.makeSplashView()
        case .mainMenu:
            viewFactory.makeMainMenuView()
        case .newGame:
            viewFactory.makeNewGameView()
        case .teamSelect:
            viewFactory.makeTeamSelectView()
        }
    }
}
