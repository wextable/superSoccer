//
//  NavigationCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

import Combine
import Foundation

/// Protocol defining the navigation coordination capabilities
@MainActor
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

/// Coordinator that handles navigation between screens
final class NavigationCoordinator: NavigationCoordinatorProtocol {
    private let router: NavigationRouter
    
    init(router: NavigationRouter) {
        self.router = router
    }
    
    func navigateToScreen(_ screen: NavigationRouter.Screen) {
        router.navigate(to: screen)
    }
    
    func replaceStackWith(_ screen: NavigationRouter.Screen) {
        router.replaceNavigationStack(with: screen)
    }
    
    func popToRoot() {
        router.popToRoot()
    }
    
    func popScreen() {
        router.pop()
    }
    
    func presentSheet(_ screen: NavigationRouter.Screen) {
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
    var replaceStackWithCalled = false
    func replaceStackWith(_ screen: NavigationRouter.Screen) {
        screenToReplaceStack = screen
        replaceStackWithCalled = true
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
