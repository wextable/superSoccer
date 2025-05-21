//
//  InteractorFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 5/21/25.
//

protocol InteractorFactory {
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol
    func makeTeamDetailInteractor(teamId: String) -> TeamDetailInteractorProtocol
}

final class DefaultInteractorFactory: InteractorFactory {
    private let dependencies: DependencyContaining
    private let router: NavigationRouter
    
    init(dependencies: DependencyContaining, router: NavigationRouter) {
        self.dependencies = dependencies
        self.router = router
    }
    
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol {
        return TeamSelectInteractor(
            router: router,
            dataManager: dependencies.dataManager
        )
    }
    
    func makeTeamDetailInteractor(teamId: String) -> TeamDetailInteractorProtocol {
        return TeamDetailInteractor(
            router: router,
            teamId: teamId,
            dataManager: dependencies.dataManager
        )
    }
}
