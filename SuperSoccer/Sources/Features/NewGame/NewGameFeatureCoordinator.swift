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
        navigationCoordinator.navigateToScreen(.newGame(interactor: interactor))
    }
    
    override func finish(with result: NewGameCoordinatorResult) {
        super.finish(with: result)
    }
    
    private func startTeamSelection() {
        let teamSelectCoordinator = TeamSelectFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            dataManager: dataManager
        )
        
        startChild(teamSelectCoordinator) { [weak self] result in
            switch result {
            case .teamSelected(let teamInfo):
                self?.navigationCoordinator.dismissSheet()
                // Update interactor with selected team using new architecture
                self?.interactor.updateSelectedTeam(teamInfo)
            case .cancelled:
                self?.navigationCoordinator.dismissSheet()
            }
        }
    }
    
    private func handleError(_ error: Error) {
        // Handle error appropriately
        print("Error in NewGame: \(error)")
    }
}

extension NewGameFeatureCoordinator: NewGameInteractorDelegate {
    func interactorDidRequestTeamSelection() {
        startTeamSelection()
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
