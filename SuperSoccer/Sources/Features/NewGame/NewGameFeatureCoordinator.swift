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

protocol NewGameFeatureCoordinatorProtocol: AnyObject {
}

class NewGameFeatureCoordinator: BaseFeatureCoordinator<NewGameCoordinatorResult>, NewGameFeatureCoordinatorProtocol, ObservableObject {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    private let interactor: NewGameInteractor
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        
        interactor = NewGameInteractor(dataManager: dataManager)
        
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
            dataManager: dataManager
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

#if DEBUG
class MockNewGameFeatureCoordinator: NewGameFeatureCoordinatorProtocol {

}
#endif
