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
    private let interactor: TeamSelectInteractorProtocol
    
    init(navigationCoordinator: NavigationCoordinatorProtocol,
         interactorFactory: InteractorFactoryProtocol) {
        self.navigationCoordinator = navigationCoordinator
        
        interactor = interactorFactory.makeTeamSelectInteractor()
        
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

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamSelectFeatureCoordinator {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: TeamSelectFeatureCoordinator
        
        var childCoordinators: [any BaseFeatureCoordinatorType] { target.testChildCoordinators }
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var interactor: TeamSelectInteractorProtocol { target.interactor }
        
        func simulateChildFinish<ChildResult: CoordinatorResult>(
            _ childCoordinator: BaseFeatureCoordinator<ChildResult>,
            with result: ChildResult
        ) {
            childCoordinator.finish(with: result)
        }
    }
}

#endif
