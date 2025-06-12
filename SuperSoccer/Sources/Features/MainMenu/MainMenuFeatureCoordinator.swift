//
//  MainMenuFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

enum MainMenuCoordinatorResult: CoordinatorResult {
    case newGameCreated(CreateNewCareerResult)
}

protocol MainMenuFeatureCoordinatorProtocol: AnyObject {
    func handleNewGameSelected()
}

class MainMenuFeatureCoordinator: BaseFeatureCoordinator<MainMenuCoordinatorResult>, MainMenuFeatureCoordinatorProtocol, ObservableObject {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let coordinatorRegistry: FeatureCoordinatorRegistryProtocol
    private let dataManager: DataManagerProtocol

    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         coordinatorRegistry: FeatureCoordinatorRegistryProtocol,
         dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.coordinatorRegistry = coordinatorRegistry
        self.dataManager = dataManager
        super.init()
    }
    
    override func start() {
        coordinatorRegistry.register(self, for: .mainMenu)
        // Don't navigate to mainMenu here - RootCoordinator handles navigation
    }
    
    override func finish(with result: MainMenuCoordinatorResult) {
        coordinatorRegistry.unregister(for: .mainMenu)
        super.finish(with: result)
    }
    
    func handleNewGameSelected() {
        let newGameCoordinator = NewGameFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
        
        startChild(newGameCoordinator) { [weak self] result in
            guard let self else { return }
            switch result {
            case .gameCreated(let createGameResult):
                self.finish(with: .newGameCreated(createGameResult))
            case .cancelled:
                // User cancelled new game creation, stay on main menu
                break
            }
        }
    }
}

#if DEBUG
class MockMainMenuFeatureCoordinator: MainMenuFeatureCoordinatorProtocol {
    var handleNewGameSelectedCalled = false
    func handleNewGameSelected() {
        handleNewGameSelectedCalled = true
    }
}
#endif
