import SwiftUI

@MainActor
protocol ViewFactory {
    func makeSplashView(coordinator: RootCoordinator) -> SplashView<SplashViewInteractor>
    func makeTeamSelectView(router: NavigationRouter) -> TeamSelectView<TeamSelectInteractor>
    func makeTeamDetailView(teamId: String, router: NavigationRouter) -> TeamDetailView<TeamDetailInteractor>
//    func makePlayerListView(teamId: String) -> some View
}


final class AppViewFactory: ViewFactory {
    private let dataManager: DataManager
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
    }
    
    func makeSplashView(coordinator: RootCoordinator) -> SplashView<SplashViewInteractor> {
        let interactor = SplashViewInteractor(coordinator: coordinator)
        return SplashView(interactor: interactor)
    }
    
    func makeTeamSelectView(router: NavigationRouter) -> TeamSelectView<TeamSelectInteractor> {
        let interactor = TeamSelectInteractor(router: router, dataManager: dataManager)
        return TeamSelectView(interactor: interactor)
    }
    
    func makeTeamDetailView(teamId: String, router: NavigationRouter) -> TeamDetailView<TeamDetailInteractor> {
        let interactor = TeamDetailInteractor(router: router, teamId: teamId, dataManager: dataManager)
//        interactor.router = router
        return TeamDetailView(interactor: interactor)
    }
//    
//    func makePlayerListView(teamId: String) -> some View {
//        Text("Player List \(teamId)") // Placeholder until PlayerListView is implemented
//    }
}
