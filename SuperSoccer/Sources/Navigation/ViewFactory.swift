import SwiftUI

@MainActor
protocol ViewFactoryProtocol {
    func makeSplashView(coordinator: RootCoordinator) -> SplashView<SplashViewInteractor>
    func makeMainMenuView() -> MainMenuView<MainMenuInteractor>
    func makeTeamSelectView() -> TeamSelectView<TeamSelectInteractor>
    func makeTeamDetailView(teamId: String) -> TeamDetailView<TeamDetailInteractor>
}

final class ViewFactory: ViewFactoryProtocol {
    private let interactorFactory: InteractorFactoryProtocol
    
    init(interactorFactory: InteractorFactoryProtocol) {
        self.interactorFactory = interactorFactory
    }
    
    func makeSplashView(coordinator: RootCoordinator) -> SplashView<SplashViewInteractor> {
        let interactor = SplashViewInteractor(coordinator: coordinator)
        return SplashView(interactor: interactor)
    }
    
    func makeMainMenuView() -> MainMenuView<MainMenuInteractor> {
        let interactor = interactorFactory.makeMainMenuInteractor()
        return MainMenuView(interactor: interactor as! MainMenuInteractor)
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
