//
//  NavigationCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

import Combine
import Foundation

/// Protocol defining the navigation coordination capabilities
protocol NavigationCoordinatorProtocol {
    /// Navigate to a specific screen
    func navigateToScreen(_ screen: NavigationRouter.Screen)
    
    /// Replace the navigation stack with a specific screen
    func replaceStackWith(_ screen: NavigationRouter.Screen)
    
    /// Pop to the root of the navigation stack
    func popToRoot()
    
    /// Pop the last screen from the navigation stack
    func popScreen()
    
    /// Present a sheet with a specific screen
    func presentSheet(_ screen: NavigationRouter.Screen)
    
    /// Dismiss the currently presented sheet
    func dismissSheet()
}

/// Coordinator that handles navigation between screens and manages feature coordinators
final class NavigationCoordinator: NavigationCoordinatorProtocol {
    private let router: NavigationRouter
    private let coordinatorRegistry: FeatureCoordinatorRegistryProtocol
    private let dataManager: DataManagerProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        router: NavigationRouter,
        coordinatorRegistry: FeatureCoordinatorRegistryProtocol,
        dataManager: DataManagerProtocol
    ) {
        self.router = router
        self.coordinatorRegistry = coordinatorRegistry
        self.dataManager = dataManager
        setupEventSubscriptions()
    }
    
    private func setupEventSubscriptions() {
        // Subscribe to navigation path changes to manage feature coordinators
        router.$screens
            .sink { [weak self] screens in
                self?.handleNavigationPathChange(screens)
            }
            .store(in: &cancellables)
    }
    
    private func handleNavigationPathChange(_ path: [NavigationRouter.Screen]) {
        // Clean up coordinators for screens no longer in the path
        cleanupInactiveCoordinators(currentPath: path)
        
        // Ensure coordinators exist for all screens in the path
        ensureCoordinatorsForPath(path)
    }
    
    private func cleanupInactiveCoordinators(currentPath: [NavigationRouter.Screen]) {
        // This would need to track which coordinators are active
        // and clean up those not in the current path
        // For now, we'll keep it simple and let coordinators manage their own lifecycle
    }
    
    private func ensureCoordinatorsForPath(_ path: [NavigationRouter.Screen]) {
        for screen in path {
            ensureCoordinatorExists(for: screen)
        }
    }
    
    private func ensureCoordinatorExists(for screen: NavigationRouter.Screen) {
        // Check if coordinator already exists
        switch screen {
        case .splash:
            break
            
        case .mainMenu:
            if coordinatorRegistry.coordinator(for: screen, as: MainMenuFeatureCoordinatorProtocol.self) == nil {
                let coordinator = MainMenuFeatureCoordinator(
                    navigationCoordinator: self,
                    coordinatorRegistry: coordinatorRegistry,
                    dataManager: dataManager
                )
                coordinatorRegistry.register(coordinator, for: screen)
            }
            
        case .newGame:
            if coordinatorRegistry.coordinator(for: screen, as: NewGameFeatureCoordinatorProtocol.self) == nil {
                let coordinator = NewGameFeatureCoordinator(
                    navigationCoordinator: self,
                    coordinatorRegistry: coordinatorRegistry,
                    dataManager: dataManager
                )
                coordinatorRegistry.register(coordinator, for: screen)
            }
            
        case .teamSelect:
            if coordinatorRegistry.coordinator(for: screen, as: TeamSelectFeatureCoordinatorProtocol.self) == nil {
                let coordinator = TeamSelectFeatureCoordinator(
                    navigationCoordinator: self,
                    coordinatorRegistry: coordinatorRegistry,
                    dataManager: dataManager
                )
                coordinatorRegistry.register(coordinator, for: screen)
            }
        }
    }
    
    // MARK: - NavigationCoordinating
    
    func navigateToScreen(_ screen: NavigationRouter.Screen) {
        ensureCoordinatorExists(for: screen)
        router.navigate(to: screen)
    }
    
    func replaceStackWith(_ screen: NavigationRouter.Screen) {
        ensureCoordinatorExists(for: screen)
        router.replaceNavigationStack(with: screen)
    }
    
    func popToRoot() {
        router.popToRoot()
    }
    
    func popScreen() {
        router.pop()
    }
    
    func presentSheet(_ screen: NavigationRouter.Screen) {
        ensureCoordinatorExists(for: screen)
        router.presentedSheet = screen
    }
    
    func dismissSheet() {
        router.dismissSheet()
    }
}

#if DEBUG
class MockNavigationCoordinator: NavigationCoordinatorProtocol {
    var screenNavigatedTo: NavigationRouter.Screen?
    func navigateToScreen(_ screen: NavigationRouter.Screen) {
        screenNavigatedTo = screen
    }
    
    var screenToReplaceStack: NavigationRouter.Screen?
    func replaceStackWith(_ screen: NavigationRouter.Screen) {
        screenToReplaceStack = screen
    }
    
    var didCallPopToRoot = false
    func popToRoot() {
        didCallPopToRoot = true
    }
    
    var didCallPopScreen = false
    func popScreen() {
        didCallPopScreen = true
    }
    
    var screenToPresent: NavigationRouter.Screen?
    func presentSheet(_ screen: NavigationRouter.Screen) {
        screenToPresent = screen
    }
    
    var didCallDismissSheet = false
    func dismissSheet() {
        didCallDismissSheet = true
    }
}
#endif
