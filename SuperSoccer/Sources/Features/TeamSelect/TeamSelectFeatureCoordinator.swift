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
}

class TeamSelectFeatureCoordinator: BaseFeatureCoordinator<TeamSelectCoordinatorResult>, TeamSelectFeatureCoordinatorProtocol {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    private let interactor: TeamSelectInteractor
    
    init(navigationCoordinator: NavigationCoordinatorProtocol,
         dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        
        interactor = TeamSelectInteractor(dataManager: dataManager)
        
        super.init()
        
        interactor.delegate = self
    }
    
    override func start() {
        navigationCoordinator.presentSheet(.teamSelect(interactor: interactor))
    }
    
    override func finish(with result: TeamSelectCoordinatorResult) {
        super.finish(with: result)
    }

}

extension TeamSelectFeatureCoordinator: TeamSelectInteractorDelegate {
    func interactorDidSelectTeam(_ team: TeamInfo) {
        finish(with: .teamSelected(team))
    }
    
    func interactorDidCancel() {
        finish(with: .cancelled)
    }
}

#if DEBUG
class MockTeamSelectFeatureCoordinator: TeamSelectFeatureCoordinatorProtocol {

}
#endif
