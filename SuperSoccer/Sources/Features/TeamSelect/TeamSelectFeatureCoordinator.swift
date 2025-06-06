//
//  TeamSelectFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

protocol TeamSelectFeatureCoordinatorProtocol: AnyObject {
    var state: TeamSelectState { get }
    var statePublisher: AnyPublisher<TeamSelectState, Never> { get }
    
    func handleTeamSelected(_ team: TeamInfo)
    func handleUserCancelled()
}

class TeamSelectFeatureCoordinator: BaseFeatureCoordinator<TeamSelectCoordinatorResult>, TeamSelectFeatureCoordinatorProtocol {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let coordinatorRegistry: FeatureCoordinatorRegistryProtocol
    private let dataManager: DataManagerProtocol
    
    @Published private(set) var state = TeamSelectState()
    var statePublisher: AnyPublisher<TeamSelectState, Never> {
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
        coordinatorRegistry.register(self, for: .teamSelect)
        navigationCoordinator.presentSheet(.teamSelect)
        loadTeams()
    }
    
    override func finish(with result: TeamSelectCoordinatorResult) {
        coordinatorRegistry.unregister(for: .teamSelect)
        super.finish(with: result)
    }
    
    func handleTeamSelected(_ team: TeamInfo) {
        finish(with: .teamSelected(team))
    }
    
    func handleUserCancelled() {
        finish(with: .cancelled)
    }
    
    private func loadTeams() {
        state = TeamSelectState(teams: [], isLoading: true)
        
        // Load teams from data manager
//        let teams = dataManager.teamInfos()
//        state = TeamSelectState(teams: teams, isLoading: false)
    }
}

#if DEBUG
class MockTeamSelectFeatureCoordinator: TeamSelectFeatureCoordinatorProtocol {
    @Published var state = TeamSelectState()
    var statePublisher: AnyPublisher<TeamSelectState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    // Test tracking properties
    var handleTeamSelectedCalled = false
    var handleUserCancelledCalled = false
    var lastSelectedTeam: TeamInfo?
    var lastDetailTeam: TeamInfo?
    
    func handleTeamSelected(_ team: TeamInfo) {
        handleTeamSelectedCalled = true
        lastSelectedTeam = team
    }
    
    func handleUserCancelled() {
        handleUserCancelledCalled = true
    }
}
#endif
