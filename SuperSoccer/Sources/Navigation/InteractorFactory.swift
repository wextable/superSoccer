//
//  InteractorFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

protocol InteractorFactoryProtocol {
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol
    func makeTeamDetailInteractor(teamId: String) -> TeamDetailInteractorProtocol
}

final class InteractorFactory: InteractorFactoryProtocol {
    private let dependencies: DependencyContainerProtocol
    
    init(dependencies: DependencyContainerProtocol) {
        self.dependencies = dependencies
    }
    
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol {
        return TeamSelectInteractor(
            navigationCoordinator: dependencies.navigationCoordinator,
            dataManager: dependencies.dataManager
        )
    }
    
    func makeTeamDetailInteractor(teamId: String) -> TeamDetailInteractorProtocol {
        return TeamDetailInteractor(
            navigationCoordinator: dependencies.navigationCoordinator,
            teamId: teamId,
            dataManager: dependencies.dataManager
        )
    }
}

#if DEBUG
class MockInteractorFactory: InteractorFactoryProtocol {
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol {
        return MockTeamSelectInteractor()
    }
    
    func makeTeamDetailInteractor(teamId: String) -> TeamDetailInteractorProtocol {
        return MockTeamDetailInteractor()
    }
}
#endif
