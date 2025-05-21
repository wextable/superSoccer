//
//  DependencyContainer.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

protocol DependencyContaining {
    var dataManager: DataManager { get }
    var interactorFactory: InteractorFactory { get }
}

final class DependencyContainer: DependencyContaining {
    @MainActor static let shared = DependencyContainer()
    
    // Dependencies
    private(set) lazy var dataManager: DataManager = {
        SwiftDataManagerFactory.shared.makeDataManager()
    }()
    
    // Factories
    private(set) lazy var interactorFactory: InteractorFactory = {
        DefaultInteractorFactory(dependencies: self, router: router)
    }()
//    
//    private(set) lazy var viewFactory: ViewFactory = {
//        ViewFactory(interactorFactory: interactorFactory)
//    }()
//    
    private(set) lazy var router = NavigationRouter()
    
    private init() {}
}
