//
//  InteractorFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

protocol InteractorFactoryProtocol {
    func makeMainMenuInteractor() -> MainMenuInteractorProtocol
    func makeNewGameInteractor() -> NewGameInteractorProtocol
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol
    func makeTeamDetailInteractor(teamInfo: TeamInfo) -> TeamDetailInteractorProtocol
}

final class InteractorFactory: InteractorFactoryProtocol {
    private let dependencies: DependencyContainerProtocol
    
    init(dependencies: DependencyContainerProtocol) {
        self.dependencies = dependencies
    }
    
    func makeMainMenuInteractor() -> MainMenuInteractorProtocol {
        return MainMenuInteractor(
            navigationCoordinator: dependencies.navigationCoordinator,
            dataManager: dependencies.dataManager
        )
    }

    func makeNewGameInteractor() -> NewGameInteractorProtocol {
        return NewGameInteractor(
            navigationCoordinator: dependencies.navigationCoordinator,
            dataManager: dependencies.dataManager
        )
    }

    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol {
        return TeamSelectInteractor(
            navigationCoordinator: dependencies.navigationCoordinator,
            dataManager: dependencies.dataManager
        )
    }
    
    func makeTeamDetailInteractor(teamInfo: TeamInfo) -> TeamDetailInteractorProtocol {
        return TeamDetailInteractor(
            navigationCoordinator: dependencies.navigationCoordinator,
            teamInfo: teamInfo,
            dataManager: dependencies.dataManager
        )
    }
}

#if DEBUG
class MockInteractorFactory: InteractorFactoryProtocol {
    func makeNewGameInteractor() -> any NewGameInteractorProtocol {
        return MockNewGameInteractor()
    }
    
    func makeMainMenuInteractor() -> any MainMenuInteractorProtocol {
        return MockMainMenuInteractor()
    }
    
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol {
        return MockTeamSelectInteractor()
    }
    
    func makeTeamDetailInteractor(teamInfo: TeamInfo) -> TeamDetailInteractorProtocol {
        return MockTeamDetailInteractor()
    }
}
#endif
