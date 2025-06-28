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

@MainActor
class TeamFeatureCoordinator: BaseFeatureCoordinator<TeamCoordinatorResult> {
    private let userTeamId: String
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let interactorFactory: InteractorFactoryProtocol
    private var interactor: TeamInteractorProtocol?
    
    init(userTeamId: String,
         navigationCoordinator: NavigationCoordinatorProtocol,
         interactorFactory: InteractorFactoryProtocol) {
        self.userTeamId = userTeamId
        self.navigationCoordinator = navigationCoordinator
        self.interactorFactory = interactorFactory
        super.init()
    }
    
    override func start() {
        Task { @MainActor in
            let teamInteractor = interactorFactory.makeTeamInteractor(userTeamId: userTeamId)
            teamInteractor.delegate = self
            self.interactor = teamInteractor
            
            let teamScreen = NavigationRouter.Screen.team(interactor: teamInteractor)
            self.navigationCoordinator.replaceStackWith(teamScreen)
        }        
    }
}

extension TeamFeatureCoordinator: TeamInteractorDelegate {
    func playerRowTapped(_ playerId: String) {
        finish(with: .playerSelected(playerId: playerId))
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamFeatureCoordinator {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    @MainActor
    struct TestHooks {
        let target: TeamFeatureCoordinator
        
        var childCoordinators: [any BaseFeatureCoordinatorType] { target.testChildCoordinators }
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var interactorFactory: InteractorFactoryProtocol { target.interactorFactory }
        var userTeamId: String { target.userTeamId }
        var interactor: TeamInteractorProtocol? { target.interactor }
        
        func simulateChildFinish<ChildResult: CoordinatorResult>(
            _ childCoordinator: BaseFeatureCoordinator<ChildResult>,
            with result: ChildResult
        ) {
            childCoordinator.finish(with: result)
        }
    }
}
#endif
