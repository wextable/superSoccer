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
    private let dataManager: DataManager
    private let viewFactory: ViewFactory
    @StateObject private var router = NavigationRouter()
    
    init() {
        let factory = SwiftDataManagerFactory()
        dataManager = factory.makeDataManager()
        viewFactory = AppViewFactory(dataManager: dataManager)
    }
    
    var body: some Scene {
        WindowGroup {
            switch coordinator.appState {
            case .splash:
                viewFactory.makeSplashView(coordinator: coordinator)
                    .transition(.opacity)
            case .main:
                NavigationStack(path: $router.path) {
                    viewFactory.makeTeamSelectView(router: router)
                        .modifier(NavigationConfigurator(viewFactory: viewFactory, router: router))
                }
                .transition(.opacity)
            }
        }
    }
}
