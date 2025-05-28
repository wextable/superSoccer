//
//  TeamInfoSelectInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import Combine
import Observation

typealias TeamSelectEventBus = PassthroughSubject<TeamSelectEvent, Never>

enum TeamSelectEvent: BusEvent {
    case teamSelected(teamId: String)
}

protocol TeamSelectInteractorProtocol: AnyObject {
    var viewModel: TeamSelectViewModel { get }
    var eventBus: TeamSelectEventBus { get }
}
    
@Observable
final class TeamSelectInteractor: TeamSelectInteractorProtocol {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    let eventBus = TeamSelectEventBus()
    
    var viewModel: TeamSelectViewModel = .init(clientModels: [])
    
    private var clientModels: [TeamInfo] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(
        navigationCoordinator: NavigationCoordinatorProtocol,
        dataManager: DataManagerProtocol
    ) {
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        
        clientModels = dataManager.teamInfos()
        viewModel = TeamSelectViewModel(clientModels: clientModels)
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
//        subscribeToDataSource()
        subscribeToEvents()
    }
    
//    private func subscribeToDataSource() {
//        dataManager.teamPublisher
//            .sink { [weak self] teams in
//                guard let self else { return }
//                self.clientModels = teams.map(\.info)
//                self.viewModel = TeamSelectViewModel(clientModels: self.clientModels)
//            }
//            .store(in: &cancellables)
//    }
    
    private func subscribeToEvents() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .teamSelected(let teamId):
                    self?.handleTeamSelected(teamId: teamId)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleTeamSelected(teamId: String) {
//        guard let teamInfo = clientModels.first(where: { $0.id == teamId }) else { return }
    }
}

#if DEBUG
extension TeamSelectInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: TeamSelectInteractor
        
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var dataManager: DataManagerProtocol { target.dataManager }
    }
}

class MockTeamSelectInteractor: TeamSelectInteractorProtocol {
    var mockTeamModels: [TeamThumbnailViewModel] = [
        TeamThumbnailViewModel.make(id: "1", text: "Team A"),
        TeamThumbnailViewModel.make(id: "2", text: "Team B"),
        TeamThumbnailViewModel.make(id: "3", text: "Team C")
    ]
    var viewModel: TeamSelectViewModel {
        TeamSelectViewModel(
            title: "Select a team",
            teamModels: mockTeamModels
        )
    }
    var eventBus: TeamSelectEventBus = TeamSelectEventBus()
}
#endif
