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
    private let container: DependencyContainerProtocol
    @ObservedObject private var router: NavigationRouter
    private let rootCoordinator: RootCoordinator
    
    init() {
        container = DependencyContainer.shared
        router = container.router
        rootCoordinator = RootCoordinator(
            navigationCoordinator: container.navigationCoordinator,
            coordinatorRegistry: container.coordinatorRegistry,
            dataManager: container.dataManager
        )
        
        // Start the root coordinator
        rootCoordinator.start()
    }
    
    var body: some Scene {
        WindowGroup {
            RootNavigationView(viewFactory: container.viewFactory)
                .environmentObject(router)
        }
    }
}

struct RootNavigationView: View {
    @EnvironmentObject private var router: NavigationRouter
    let viewFactory: ViewFactoryProtocol
    
    var body: some View {
        // Show the appropriate view based on current navigation state
        NavigationStack(path: $router.path) {
            if router.screens.isEmpty {
                // No navigation screens, show splash
                viewFactory.makeSplashView()
            } else {
                // Show the first screen in the navigation stack as the "root"
                // All other screens will be handled by NavigationConfigurator
                viewFactory.makeView(for: router.screens[0])
                    .modifier(NavigationConfigurator(viewFactory: viewFactory, router: router))
            }
        }
    }
}
