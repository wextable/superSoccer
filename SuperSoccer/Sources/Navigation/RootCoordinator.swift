//
//  RootCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Foundation
import Combine

protocol RootCoordinatorProtocol: AnyObject {
    func start()
}

class RootCoordinator: BaseFeatureCoordinator<RootCoordinatorResult>, RootCoordinatorProtocol, ObservableObject {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let coordinatorRegistry: FeatureCoordinatorRegistryProtocol
    private let dataManager: DataManagerProtocol
    private var splashTimer: Timer?
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         coordinatorRegistry: FeatureCoordinatorRegistryProtocol,
         dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.coordinatorRegistry = coordinatorRegistry
        self.dataManager = dataManager
        super.init()
    }
    
    override func start() {
        startSplashTimer()
    }
    
    private func startSplashTimer() {
        // Start a 3-second timer for the splash screen
        splashTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.splashTimer?.invalidate()
            self.splashTimer = nil
            self.startMainMenuFlow()
        }
    }
    
    deinit {
        splashTimer?.invalidate()
        splashTimer = nil
    }
    
    private func startMainMenuFlow() {
        let mainMenuCoordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
        
        // Start the coordinator first so it registers itself
        startChild(mainMenuCoordinator) { [weak self] result in
            switch result {
            case .newGameSelected:
                self?.startNewGameFlow()
            case .settingsSelected:
                // Handle settings flow
                break
            case .exitSelected:
                self?.finish(with: .appShouldExit)
            }
        }
        
        // Navigate to main menu screen AFTER coordinator is started and registered
        navigationCoordinator.replaceStackWith(.mainMenu)
    }
    
    private func startNewGameFlow() {
        let newGameCoordinator = NewGameFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
        
        // Use startChild to handle the new game coordinator
        startChild(newGameCoordinator) { [weak self] result in
            switch result {
            case .gameStarted:
                break
            case .cancelled:
                // Go back to main menu
                self?.startMainMenuFlow()
            }
        }
        
        // Navigate to new game screen
        navigationCoordinator.navigateToScreen(.newGame)
    }
    
    private func startTeamSelectFlow() {
        let teamSelectCoordinator = TeamSelectFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
        
        // Use startChild to handle the team select coordinator
        startChild(teamSelectCoordinator) { [weak self] result in
            switch result {
            case .teamSelected(let teamInfo):
                break
            case .cancelled:
                // Go back to new game
                self?.startNewGameFlow()
            }
        }
        
        // Navigate to team select screen
        navigationCoordinator.navigateToScreen(.teamSelect)
    }
    
}

#if DEBUG
class MockRootCoordinator: RootCoordinatorProtocol {
    var startCalled = false
    
    func start() {
        startCalled = true
    }
}
#endif
