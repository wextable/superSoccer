//
//  NewGameFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

protocol NewGameFeatureCoordinatorProtocol: AnyObject {
    var state: NewGameState { get }
    var statePublisher: AnyPublisher<NewGameState, Never> { get }
    
    func updateCoachInfo(firstName: String, lastName: String)
    func startTeamSelection()
    func handleGameStart()
}

class NewGameFeatureCoordinator: BaseFeatureCoordinator<NewGameCoordinatorResult>, NewGameFeatureCoordinatorProtocol, ObservableObject {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let coordinatorRegistry: FeatureCoordinatorRegistryProtocol
    private let dataManager: DataManagerProtocol
    
    @Published private(set) var state = NewGameState()
    var statePublisher: AnyPublisher<NewGameState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    private var selectedTeam: TeamInfo?
    private var coachInfo: CoachInfo?
    
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
    
    func updateCoachInfo(firstName: String, lastName: String) {
        coachInfo = CoachInfo(firstName: firstName, lastName: lastName)
        updateState()
    }
    
    func startTeamSelection() {
        let teamSelectCoordinator = TeamSelectFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
        
        startChild(teamSelectCoordinator) { [weak self] result in
            switch result {
            case .teamSelected(let team):
                self?.selectedTeam = team
                self?.navigationCoordinator.dismissSheet()
                self?.updateState()
            case .cancelled:
                self?.navigationCoordinator.dismissSheet()
            }
        }
    }
    
    func handleGameStart() {
        guard let team = selectedTeam, let coach = coachInfo else { return }
        let gameInfo = GameInfo(team: team, coach: coach)
        finish(with: .gameStarted(gameInfo))
    }
    
    private func updateState() {
        state = NewGameState(selectedTeam: selectedTeam, coachInfo: coachInfo)
    }
    
    private func handleError(_ error: Error) {
        // Handle error appropriately
        print("Error in NewGame: \(error)")
    }
}

#if DEBUG
class MockNewGameFeatureCoordinator: NewGameFeatureCoordinatorProtocol {
    @Published var state = NewGameState()
    var statePublisher: AnyPublisher<NewGameState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    // Test tracking properties
    var updateCoachInfoCalled = false
    var startTeamSelectionCalled = false
    var handleGameStartCalled = false
    var lastCoachInfo: (firstName: String, lastName: String)?
    
    func updateCoachInfo(firstName: String, lastName: String) {
        updateCoachInfoCalled = true
        lastCoachInfo = (firstName, lastName)
        state = NewGameState(
            selectedTeam: state.selectedTeam,
            coachInfo: CoachInfo(firstName: firstName, lastName: lastName)
        )
    }
    
    func startTeamSelection() {
        startTeamSelectionCalled = true
    }
    
    func handleGameStart() {
        handleGameStartCalled = true
    }
}
#endif
