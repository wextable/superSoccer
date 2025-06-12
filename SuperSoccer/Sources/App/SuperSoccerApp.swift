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
