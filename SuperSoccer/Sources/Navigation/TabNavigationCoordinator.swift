//
//  TabNavigationCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import Foundation

class TabNavigationCoordinator: NavigationCoordinatorProtocol {
    private let tab: TabType
    private let parentNavigationCoordinator: NavigationCoordinatorProtocol
    
    init(tab: TabType, parentNavigationCoordinator: NavigationCoordinatorProtocol) {
        self.tab = tab
        self.parentNavigationCoordinator = parentNavigationCoordinator
    }
    
    func navigateToScreen(_ screen: NavigationRouter.Screen) {
        TabNavigationManager.shared.navigate(to: screen, in: tab)
    }
    
    func replaceStackWith(_ screen: NavigationRouter.Screen) {
        TabNavigationManager.shared.replaceStack(with: screen, in: tab)
    }
    
    func popToRoot() {
        TabNavigationManager.shared.popToRoot(in: tab)
    }
    
    func popScreen() {
        TabNavigationManager.shared.pop(in: tab)
    }
    
    func presentSheet(_ screen: NavigationRouter.Screen) {
        parentNavigationCoordinator.presentSheet(screen)
    }
    
    func dismissSheet() {
        parentNavigationCoordinator.dismissSheet()
    }
}

#if DEBUG
class MockTabNavigationCoordinator: NavigationCoordinatorProtocol {
    var screenNavigatedTo: NavigationRouter.Screen?
    var screenToReplaceStack: NavigationRouter.Screen?
    var didCallPopToRoot = false
    var didCallPopScreen = false
    var screenToPresent: NavigationRouter.Screen?
    var didCallDismissSheet = false
    
    func navigateToScreen(_ screen: NavigationRouter.Screen) {
        screenNavigatedTo = screen
    }
    
    func replaceStackWith(_ screen: NavigationRouter.Screen) {
        screenToReplaceStack = screen
    }
    
    func popToRoot() {
        didCallPopToRoot = true
    }
    
    func popScreen() {
        didCallPopScreen = true
    }
    
    func presentSheet(_ screen: NavigationRouter.Screen) {
        screenToPresent = screen
    }
    
    func dismissSheet() {
        didCallDismissSheet = true
    }
}
#endif
