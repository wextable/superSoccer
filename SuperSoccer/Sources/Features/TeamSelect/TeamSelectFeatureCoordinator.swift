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

class TeamSelectFeatureCoordinator: BaseFeatureCoordinator<TeamSelectCoordinatorResult> {
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
        Task { @MainActor in
            self.navigationCoordinator.presentSheet(.teamSelect(interactor: interactor))
        }
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
extension TeamSelectFeatureCoordinator {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: TeamSelectFeatureCoordinator
        
        var childCoordinators: [any BaseFeatureCoordinatorType] { target.testChildCoordinators }
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var dataManager: DataManagerProtocol { target.dataManager }
        var interactor: TeamSelectInteractor { target.interactor }
        
        func simulateChildFinish<ChildResult: CoordinatorResult>(
            _ childCoordinator: BaseFeatureCoordinator<ChildResult>,
            with result: ChildResult
        ) {
            childCoordinator.finish(with: result)
        }
    }
}

#endif
