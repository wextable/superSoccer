import SwiftUI

@MainActor
protocol ViewFactory {
    func makeSplashView(coordinator: RootCoordinator) -> SplashView<SplashViewInteractor>
    func makeTeamSelectView() -> TeamSelectView<TeamSelectInteractor>
    func makeTeamDetailView(teamId: String) -> TeamDetailView<TeamDetailInteractor>
}

final class AppViewFactory: ViewFactory {
    private let interactorFactory: InteractorFactory
    
    init(interactorFactory: InteractorFactory) {
        self.interactorFactory = interactorFactory
    }
    
    func makeSplashView(coordinator: RootCoordinator) -> SplashView<SplashViewInteractor> {
        let interactor = SplashViewInteractor(coordinator: coordinator)
        return SplashView(interactor: interactor)
    }
    
    func makeTeamSelectView() -> TeamSelectView<TeamSelectInteractor> {
        let interactor = interactorFactory.makeTeamSelectInteractor()
        return TeamSelectView(interactor: interactor as! TeamSelectInteractor)
    }
    
    func makeTeamDetailView(teamId: String) -> TeamDetailView<TeamDetailInteractor> {
        let interactor = interactorFactory.makeTeamDetailInteractor(teamId: teamId)
        return TeamDetailView(interactor: interactor as! TeamDetailInteractor)
    }
}
