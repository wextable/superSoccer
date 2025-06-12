//
//  MainMenuFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

enum MainMenuCoordinatorResult: CoordinatorResult {
    case newGameCreated(CreateNewCareerResult)
}

protocol MainMenuFeatureCoordinatorProtocol: AnyObject {
}

class MainMenuFeatureCoordinator: BaseFeatureCoordinator<MainMenuCoordinatorResult>, MainMenuFeatureCoordinatorProtocol, ObservableObject {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    private let interactor: MainMenuInteractorProtocol

    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        
        interactor = MainMenuInteractor(dataManager: dataManager)
        
        super.init()
        
        interactor.delegate = self
    }
    
    override func start() {
        navigationCoordinator.navigateToScreen(.mainMenu(interactor: interactor))
    }
    
    override func finish(with result: MainMenuCoordinatorResult) {
        super.finish(with: result)
    }
    
    func handleNewGameSelected() {
        let newGameCoordinator = NewGameFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            dataManager: dataManager
        )
        
        startChild(newGameCoordinator) { [weak self] result in
            guard let self else { return }
            switch result {
            case .gameCreated(let createGameResult):
                self.finish(with: .newGameCreated(createGameResult))
            case .cancelled:
                // User cancelled new game creation, stay on main menu
                break
            }
        }
    }
}
                                               
extension MainMenuFeatureCoordinator: MainMenuInteractorDelegate {
    func interactorDidSelectNewGame() {
        handleNewGameSelected()
    }
}
                                               

#if DEBUG
class MockMainMenuFeatureCoordinator: MainMenuFeatureCoordinatorProtocol {

}
#endif
