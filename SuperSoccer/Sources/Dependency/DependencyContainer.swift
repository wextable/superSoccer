//
//  DependencyContainer.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

protocol DependencyContainerProtocol {
    @MainActor var dataManager: DataManagerProtocol { get }
    var viewFactory: ViewFactoryProtocol { get }
    var router: NavigationRouter { get }
    @MainActor var navigationCoordinator: NavigationCoordinatorProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
    @MainActor
    static let shared = DependencyContainer()
    
    // Dependencies
    @MainActor
    private(set) lazy var dataManager: DataManagerProtocol = {
        SwiftDataManagerFactory.shared.makeDataManager()
    }()
    
    private(set) lazy var router = NavigationRouter()
    
    private(set) lazy var navigationCoordinator: NavigationCoordinatorProtocol = {
        NavigationCoordinator(router: router)
    }()
    
    // Factories    
    private(set) lazy var viewFactory: ViewFactoryProtocol = {
        ViewFactory()
    }()
    
    private init() {}
}

#if DEBUG
class MockDependencyContainer: DependencyContainerProtocol {
    var mockDataManager = MockDataManager()
    var dataManager: DataManagerProtocol { mockDataManager }
    
    var mockViewFactory = MockViewFactory()
    var viewFactory: ViewFactoryProtocol { mockViewFactory }
    
    var router = NavigationRouter()
    
    var mockNavigationCoordinator = MockNavigationCoordinator()
    var navigationCoordinator: NavigationCoordinatorProtocol { mockNavigationCoordinator }
}
#endif
