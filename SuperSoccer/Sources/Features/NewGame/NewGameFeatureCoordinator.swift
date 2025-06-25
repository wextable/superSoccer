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
    private let interactor: NewGameInteractorProtocol
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         interactorFactory: InteractorFactoryProtocol) {
        self.navigationCoordinator = navigationCoordinator
        
        interactor = interactorFactory.makeNewGameInteractor()
        
        super.init()
        
        interactor.delegate = self
    }
    
    override func start() {
        Task { @MainActor in
            self.navigationCoordinator.navigateToScreen(.newGame(interactor: interactor))
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
        interactor.updateSelectedTeam(teamInfo)
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

extension NewGameFeatureCoordinator: NewGameInteractorDelegate {
    func interactorDidRequestTeamSelection() {
        Task { @MainActor in
            self.startTeamSelection()
        }
    }
    
    func interactorDidCreateGame(with result: CreateNewCareerResult) {
        finish(with: .gameCreated(result))
    }
    
    func interactorDidCancel() {
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
        var interactor: NewGameInteractorProtocol { target.interactor }
        
        func simulateChildFinish<ChildResult: CoordinatorResult>(
            _ childCoordinator: BaseFeatureCoordinator<ChildResult>,
            with result: ChildResult
        ) {
            childCoordinator.finish(with: result)
        }
    }
}

#endif
