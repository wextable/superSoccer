//
//  TeamFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import Foundation

enum TeamCoordinatorResult: CoordinatorResult {
    case playerSelected(playerId: String)
    case dismissed
}

class TeamFeatureCoordinator: BaseFeatureCoordinator<TeamCoordinatorResult> {
    private let userTeamId: String
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    
    init(userTeamId: String,
         navigationCoordinator: NavigationCoordinatorProtocol,
         dataManager: DataManagerProtocol) {
        self.userTeamId = userTeamId
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        super.init()
    }
    
    override func start() {
        let teamInteractor = TeamInteractor(
            userTeamId: userTeamId,
            dataManager: dataManager,
            delegate: self
        )
        
        let teamScreen = NavigationRouter.Screen.team(interactor: teamInteractor)
        Task { @MainActor in
            self.navigationCoordinator.replaceStackWith(teamScreen)
        }        
    }
}

extension TeamFeatureCoordinator: TeamInteractorDelegate {
    func playerRowTapped(_ playerId: String) {
        finish(with: .playerSelected(playerId: playerId))
    }
}

#if DEBUG
class MockTeamFeatureCoordinator: TeamFeatureCoordinator {
    var startCalled = false
    
    override func start() {
        startCalled = true
    }
}
#endif
