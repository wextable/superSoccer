//
//  FeatureCoordinatorRegistry.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation

protocol FeatureCoordinatorRegistryProtocol {
    func register<T: BaseFeatureCoordinatorType>(_ coordinator: T, for screen: NavigationRouter.Screen)
    func coordinator<T>(for screen: NavigationRouter.Screen, as type: T.Type) -> T?
    func unregister(for screen: NavigationRouter.Screen)
}

class FeatureCoordinatorRegistry: FeatureCoordinatorRegistryProtocol {
    private var activeCoordinators: [String: Any] = [:]
    
    func register<T: BaseFeatureCoordinatorType>(_ coordinator: T, for screen: NavigationRouter.Screen) {
        activeCoordinators[screen.id] = coordinator
    }
    
    func coordinator<T>(for screen: NavigationRouter.Screen, as type: T.Type) -> T? {
        return activeCoordinators[screen.id] as? T
    }
    
    func unregister(for screen: NavigationRouter.Screen) {
        activeCoordinators.removeValue(forKey: screen.id)
    }
}

#if DEBUG
class MockFeatureCoordinatorRegistry: FeatureCoordinatorRegistryProtocol {
    private var mockCoordinators: [String: Any] = [:]
    
    func register<T: BaseFeatureCoordinatorType>(_ coordinator: T, for screen: NavigationRouter.Screen) {
        mockCoordinators[screen.id] = coordinator
    }
    
    func coordinator<T>(for screen: NavigationRouter.Screen, as type: T.Type) -> T? {
        return mockCoordinators[screen.id] as? T
    }
    
    func unregister(for screen: NavigationRouter.Screen) {
        mockCoordinators.removeValue(forKey: screen.id)
    }
    
    // Test helper
    func setMockCoordinator<T>(_ coordinator: T, for screen: NavigationRouter.Screen) {
        mockCoordinators[screen.id] = coordinator
    }
}
#endif
