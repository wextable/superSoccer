//
//  TeamSelectFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

enum TeamSelectCoordinatorResult: CoordinatorResult {
    case teamSelected(TeamInfo)
    case cancelled
}

protocol TeamSelectFeatureCoordinatorProtocol: AnyObject {
    func handleTeamSelected(_ team: TeamInfo)
    func handleUserCancelled()
}

class TeamSelectFeatureCoordinator: BaseFeatureCoordinator<TeamSelectCoordinatorResult>, TeamSelectFeatureCoordinatorProtocol {
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
        coordinatorRegistry.register(self, for: .teamSelect)
        navigationCoordinator.presentSheet(.teamSelect)
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
}

#if DEBUG
class MockTeamSelectFeatureCoordinator: TeamSelectFeatureCoordinatorProtocol {
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
