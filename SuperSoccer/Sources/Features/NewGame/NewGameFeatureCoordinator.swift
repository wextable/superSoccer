//
//  NewGameFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

enum NewGameCoordinatorResult: CoordinatorResult {
    case gameCreated(CreateNewCareerResult)
    case cancelled
}

class NewGameFeatureCoordinator: BaseFeatureCoordinator<NewGameCoordinatorResult> {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let businessLogic: NewGameBusinessLogic
    private let presenter: NewGameViewPresenter
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         interactorFactory: InteractorFactoryProtocol) {
        self.navigationCoordinator = navigationCoordinator
        
        let interactor = interactorFactory.makeNewGameInteractor()
        self.businessLogic = interactor
        self.presenter = interactor
        
        super.init()
        
        businessLogic.delegate = self
    }
    
    override func start() {
        Task { @MainActor in
            self.navigationCoordinator.navigateToScreen(.newGame(presenter: presenter))
        }
    }
    
    override func finish(with result: NewGameCoordinatorResult) {
        super.finish(with: result)
    }
    
    @MainActor
    private func startTeamSelection() {
        let teamSelectCoordinator = TeamSelectFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            interactorFactory: DependencyContainer.shared.interactorFactory
        )
        
        startChild(teamSelectCoordinator) { [weak self] result in
            guard let self else { return }
            Task { @MainActor in
                self.handleTeamSelectionResult(result)
            }
        }
    }
    
    @MainActor
    private func handleTeamSelectionResult(_ result: TeamSelectCoordinatorResult) {
        switch result {
        case .teamSelected(let teamInfo):
            handleTeamSelected(teamInfo: teamInfo)
        case .cancelled:
            handleTeamSelectionCancelled()
        }
    }
    
    @MainActor
    private func handleTeamSelected(teamInfo: TeamInfo) {
        navigationCoordinator.dismissSheet()
        businessLogic.updateSelectedTeam(teamInfo)
    }
    
    @MainActor
    private func handleTeamSelectionCancelled() {
        navigationCoordinator.dismissSheet()
    }
    
    private func handleError(_ error: Error) {
        // Handle error appropriately
        print("Error in NewGame: \(error)")
    }
}

extension NewGameFeatureCoordinator: NewGameBusinessLogicDelegate {
    func businessLogicDidRequestTeamSelection() {
        Task { @MainActor in
            self.startTeamSelection()
        }
    }
    
    func businessLogicDidCreateGame(with result: CreateNewCareerResult) {
        finish(with: .gameCreated(result))
    }
    
    func businessLogicDidCancel() {
        finish(with: .cancelled)
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension NewGameFeatureCoordinator {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: NewGameFeatureCoordinator
        
        var childCoordinators: [any BaseFeatureCoordinatorType] { target.testChildCoordinators }
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var businessLogic: NewGameBusinessLogic { target.businessLogic }
        var presenter: NewGameViewPresenter { target.presenter }
        
        func simulateChildFinish<ChildResult: CoordinatorResult>(
            _ childCoordinator: BaseFeatureCoordinator<ChildResult>,
            with result: ChildResult
        ) {
            childCoordinator.finish(with: result)
        }
    }
}

#endif
