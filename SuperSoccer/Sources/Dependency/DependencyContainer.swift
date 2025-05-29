//
//  DependencyContainer.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

protocol DependencyContainerProtocol {
    var dataManager: DataManagerProtocol { get }
    var viewFactory: ViewFactoryProtocol { get }
    var coordinatorRegistry: FeatureCoordinatorRegistryProtocol { get }
    var router: NavigationRouter { get }
    var navigationCoordinator: NavigationCoordinatorProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
    @MainActor
    static let shared = DependencyContainer()
    
    // Dependencies
    @MainActor
    private(set) lazy var dataManager: DataManagerProtocol = {
        SwiftDataManagerFactory.shared.makeDataManager()
    }()
    
    private(set) lazy var coordinatorRegistry: FeatureCoordinatorRegistryProtocol = {
        FeatureCoordinatorRegistry()
    }()
    
    private(set) lazy var router = NavigationRouter()
    
    private(set) lazy var navigationCoordinator: NavigationCoordinatorProtocol = {
        NavigationCoordinator(
            router: router,
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
    }()
    
    // Factories    
    private(set) lazy var viewFactory: ViewFactoryProtocol = {
        ViewFactory(
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
    }()
    
    private init() {}
}

#if DEBUG
class MockDependencyContainer: DependencyContainerProtocol {
    var mockDataManager = MockDataManager()
    var dataManager: DataManagerProtocol { mockDataManager }
    
    var mockCoordinatorRegistry = MockFeatureCoordinatorRegistry()
    var coordinatorRegistry: FeatureCoordinatorRegistryProtocol { mockCoordinatorRegistry }
    
    var mockViewFactory = MockViewFactory()
    var viewFactory: ViewFactoryProtocol { mockViewFactory }
    
    var router = NavigationRouter()
    
    var mockNavigationCoordinator = MockNavigationCoordinator()
    var navigationCoordinator: NavigationCoordinatorProtocol { mockNavigationCoordinator }
}
#endif
