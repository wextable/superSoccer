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
    private let interactor: MainMenuInteractorProtocol

    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         interactorFactory: InteractorFactoryProtocol) {
        self.navigationCoordinator = navigationCoordinator
        
        interactor = interactorFactory.makeMainMenuInteractor()
        
        super.init()
        
        interactor.delegate = self
    }
    
    override func start() {
        Task { @MainActor in
            self.navigationCoordinator.replaceStackWith(.mainMenu(presenter: interactor))
        }
    }
    
    @MainActor
    func handleNewGameSelected() {
        let newGameCoordinator = NewGameFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            interactorFactory: DependencyContainer.shared.interactorFactory
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

extension MainMenuFeatureCoordinator: MainMenuBusinessLogicDelegate {
    func businessLogicDidSelectNewGame() {
        Task { @MainActor in
            handleNewGameSelected()
        }
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension MainMenuFeatureCoordinator {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: MainMenuFeatureCoordinator
        
        var childCoordinators: [any BaseFeatureCoordinatorType] { target.testChildCoordinators }
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
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
