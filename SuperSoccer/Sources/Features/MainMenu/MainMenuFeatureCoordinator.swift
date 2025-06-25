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

class MainMenuFeatureCoordinator: BaseFeatureCoordinator<MainMenuCoordinatorResult> {
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
        Task { @MainActor in
            self.navigationCoordinator.replaceStackWith(.mainMenu(interactor: interactor))
        }
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
extension MainMenuFeatureCoordinator {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: MainMenuFeatureCoordinator
        
        var childCoordinators: [any BaseFeatureCoordinatorType] { target.testChildCoordinators }
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var dataManager: DataManagerProtocol { target.dataManager }
        var interactor: MainMenuInteractorProtocol { target.interactor }
        
        func simulateChildFinish<ChildResult: CoordinatorResult>(
            _ childCoordinator: BaseFeatureCoordinator<ChildResult>,
            with result: ChildResult
        ) {
            childCoordinator.finish(with: result)
        }
    }
}

#endif
