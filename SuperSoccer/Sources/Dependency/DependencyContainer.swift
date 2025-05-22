//
//  DependencyContainer.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

protocol DependencyContainerProtocol {
    var dataManager: DataManagerProtocol { get }
    var interactorFactory: InteractorFactoryProtocol { get }
    var router: NavigationRouter { get }
    var navigationCoordinator: NavigationCoordinatorProtocol { get }
}

final class DependencyContainer: DependencyContainerProtocol {
    @MainActor
    static let shared = DependencyContainer()
    
    // Dependencies
//    @MainActor
    private(set) lazy var dataManager: DataManagerProtocol = {
        SwiftDataManagerFactory.shared.makeDataManager()
    }()
    
    // Factories
    private(set) lazy var interactorFactory: InteractorFactoryProtocol = {
        InteractorFactory(dependencies: self)
    }()
//    
//    private(set) lazy var viewFactory: ViewFactory = {
//        ViewFactory(interactorFactory: interactorFactory)
//    }()
//    
    private(set) lazy var router = NavigationRouter()
    
    private(set) lazy var navigationCoordinator: NavigationCoordinatorProtocol = {
        NavigationCoordinator(router: router)
    }()
    
    private init() {}
}

#if DEBUG
class MockDependencyContainer: DependencyContainerProtocol {
    var mockDataManager = MockDataManager()
    var dataManager: DataManagerProtocol { mockDataManager }
    
    var mockInteractorFactory = MockInteractorFactory()
    var interactorFactory: InteractorFactoryProtocol { mockInteractorFactory }
    
    var router = NavigationRouter()
    
    var mockNavigationCoordinator = MockNavigationCoordinator()
    var navigationCoordinator: NavigationCoordinatorProtocol { mockNavigationCoordinator }
}
#endif
