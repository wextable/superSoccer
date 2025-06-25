//
//  DependencyContainer.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

import Foundation

// MARK: - DependencyContainer

protocol DependencyContainerProtocol {
    @MainActor var dataManager: DataManagerProtocol { get }
    @MainActor var viewFactory: ViewFactoryProtocol { get }
    @MainActor var router: NavigationRouter { get }
    @MainActor var navigationCoordinator: NavigationCoordinatorProtocol { get }
    @MainActor var interactorFactory: InteractorFactoryProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
    @MainActor
    static let shared = DependencyContainer()
    
    // INITIALIZATION ORDER IS CRITICAL - DO NOT REORDER
    
    // 1️⃣ FOUNDATION: Core data layer (no dependencies)
    @MainActor
    private(set) lazy var dataManager: DataManagerProtocol = {
        SwiftDataManagerFactory.shared.makeDataManager()
    }()

    // 2️⃣ NAVIGATION: Core navigation (no dependencies)
    private(set) lazy var router = NavigationRouter()
    
    private(set) lazy var navigationCoordinator: NavigationCoordinatorProtocol = {
        NavigationCoordinator(router: router)
    }()
    
    // 3️⃣ FACTORIES: Depend on foundation layer
    @MainActor
    private(set) lazy var interactorFactory: InteractorFactoryProtocol = {
        // ⚠️ DEPENDS ON: dataManager (must be initialized first)
        InteractorFactory(dataManager: dataManager)
    }()
    
    private(set) lazy var viewFactory: ViewFactoryProtocol = {
        // ✅ NO DEPENDENCIES: Can be created anytime
        ViewFactory()
    }()
    
    private init() {}
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
class MockDependencyContainer: DependencyContainerProtocol {
    var mockDataManager = MockDataManager()
    var dataManager: DataManagerProtocol { mockDataManager }
    
    var mockViewFactory = MockViewFactory()
    var viewFactory: ViewFactoryProtocol { mockViewFactory }
    
    var router = NavigationRouter()
    
    var mockNavigationCoordinator = MockNavigationCoordinator()
    var navigationCoordinator: NavigationCoordinatorProtocol { mockNavigationCoordinator }
    
    var mockInteractorFactory = MockInteractorFactory()
    var interactorFactory: InteractorFactoryProtocol { mockInteractorFactory }
    
    // 🎯 Helper methods for easy coordinator creation in tests
    func makeNewGameCoordinator() -> NewGameFeatureCoordinator {
        return NewGameFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            interactorFactory: mockInteractorFactory
        )
    }
    
    func makeMainMenuCoordinator() -> MainMenuFeatureCoordinator {
        return MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            interactorFactory: mockInteractorFactory
        )
    }
    
    func makeTeamSelectCoordinator() -> TeamSelectFeatureCoordinator {
        return TeamSelectFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            interactorFactory: mockInteractorFactory
        )
    }
    
    func makeTeamCoordinator(userTeamId: String = "mock-team-id") -> TeamFeatureCoordinator {
        return TeamFeatureCoordinator(
            userTeamId: userTeamId,
            navigationCoordinator: mockNavigationCoordinator,
            interactorFactory: mockInteractorFactory
        )
    }
}
#endif
