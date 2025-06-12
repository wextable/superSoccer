//
//  NewGameFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

enum NewGameCoordinatorResult: CoordinatorResult {
    case gameCreated(CreateNewCareerResult)
    case cancelled
}

protocol NewGameFeatureCoordinatorProtocol: AnyObject {
    func startTeamSelection()
}

class NewGameFeatureCoordinator: BaseFeatureCoordinator<NewGameCoordinatorResult>, NewGameFeatureCoordinatorProtocol, ObservableObject {
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
        coordinatorRegistry.register(self, for: .newGame)
        navigationCoordinator.navigateToScreen(.newGame)
    }
    
    override func finish(with result: NewGameCoordinatorResult) {
        coordinatorRegistry.unregister(for: .newGame)
        super.finish(with: result)
    }
    
    func startTeamSelection() {
        let teamSelectCoordinator = TeamSelectFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
        
        startChild(teamSelectCoordinator) { [weak self] result in
            switch result {
            case .teamSelected(let teamInfo):
                self?.navigationCoordinator.dismissSheet()
                // interactor needs the updated info
            case .cancelled:
                self?.navigationCoordinator.dismissSheet()
            }
        }
    }
    
    
    
    private func handleError(_ error: Error) {
        // Handle error appropriately
        print("Error in NewGame: \(error)")
    }
}

#if DEBUG
class MockNewGameFeatureCoordinator: NewGameFeatureCoordinatorProtocol {
    // Test tracking properties
    var startTeamSelectionCalled = false
    var createGameCalled = false
    
    func startTeamSelection() {
        startTeamSelectionCalled = true
    }
    
    func createGame() async {
        createGameCalled = true
    }
}
#endif
