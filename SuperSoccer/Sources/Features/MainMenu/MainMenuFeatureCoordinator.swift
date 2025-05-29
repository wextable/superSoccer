//
//  MainMenuFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

protocol MainMenuFeatureCoordinatorProtocol: AnyObject {
    var state: MainMenuState { get }
    var statePublisher: AnyPublisher<MainMenuState, Never> { get }
    
    func handleNewGameSelected()
    func handleSettingsSelected()
    func handleExitSelected()
}

class MainMenuFeatureCoordinator: BaseFeatureCoordinator<MainMenuCoordinatorResult>, MainMenuFeatureCoordinatorProtocol, ObservableObject {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let coordinatorRegistry: FeatureCoordinatorRegistryProtocol
    private let dataManager: DataManagerProtocol
    
    @Published private(set) var state = MainMenuState()
    var statePublisher: AnyPublisher<MainMenuState, Never> {
        $state.eraseToAnyPublisher()
    }
    
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
            switch result {
            case .gameStarted(let gameInfo):
                // Handle game started - could navigate to game screen or finish with result
                self?.handleGameStarted(gameInfo)
            case .cancelled:
                // User cancelled new game creation, stay on main menu
                break
//            case .teamSelectRequested:
//                break // should not be a case
            }
        }
        
//        finish(with: .newGameSelected)
    }
    
    func handleSettingsSelected() {
        // For now, just finish with settings selected
        // In the future, this could start a SettingsFeatureCoordinator
        finish(with: .settingsSelected)
    }
    
    func handleExitSelected() {
        finish(with: .exitSelected)
    }
    
    private func handleGameStarted(_ gameInfo: GameInfo) {
        // This could navigate to the actual game screen
        // For now, we'll just log it
        print("Game started with team: \(gameInfo.team.city) and coach: \(gameInfo.coach.firstName) \(gameInfo.coach.lastName)")
    }
    
    private func updateState(isLoading: Bool = false) {
        state = MainMenuState(isLoading: isLoading)
    }
}

#if DEBUG
class MockMainMenuFeatureCoordinator: MainMenuFeatureCoordinatorProtocol {
    @Published var state = MainMenuState()
    var statePublisher: AnyPublisher<MainMenuState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    // Test tracking properties
    var handleNewGameSelectedCalled = false
    var handleSettingsSelectedCalled = false
    var handleExitSelectedCalled = false
    
    func handleNewGameSelected() {
        handleNewGameSelectedCalled = true
    }
    
    func handleSettingsSelected() {
        handleSettingsSelectedCalled = true
    }
    
    func handleExitSelected() {
        handleExitSelectedCalled = true
    }
}
#endif
