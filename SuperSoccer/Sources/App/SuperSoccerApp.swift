//
//  SuperSoccerApp.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import SwiftUI
import SwiftData

@main
struct SuperSoccerApp: App {
    private let coordinator = RootCoordinator()
    private let container: DependencyContainerProtocol
    private let viewFactory: ViewFactory
    @ObservedObject private var router: NavigationRouter
    
    init() {
        container = DependencyContainer.shared
        router = container.router
        viewFactory = ViewFactory(interactorFactory: container.interactorFactory)
    }
    
    var body: some Scene {
        WindowGroup {
            switch coordinator.appState {
            case .splash:
                viewFactory.makeSplashView(coordinator: coordinator)
                    .transition(.opacity)
            case .main:
                NavigationStack(path: $router.path) {
                    viewFactory.makeTeamSelectView()
                        .modifier(NavigationConfigurator(viewFactory: viewFactory, router: router))
                }
                .transition(.opacity)
            }
        }
    }
}
