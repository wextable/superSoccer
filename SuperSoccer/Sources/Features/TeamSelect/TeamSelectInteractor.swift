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
    case teamSelected(teamInfoId: String)
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
    
    private var clientModels: [TeamInfoClientModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        subscribeToDataSource()
        subscribeToEvents()
    }
    
    private func subscribeToDataSource() {
        dataManager.teamPublisher
            .sink { [weak self] teams in
                guard let self else { return }
                self.viewModel = TeamSelectViewModel(clientModels: teams.map(\.info))
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToEvents() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .teamSelected(let teamId):
                    self?.handleTeamSelected(teamInfoId: teamId)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleTeamSelected(teamInfoId: String) {
        // Handle the team selection event here
        print("Team selected with ID: \(teamInfoId)")
        navigationCoordinator.navigateToScreen(.teamDetail(teamId: teamInfoId))
    }
}

extension TeamSelectViewModel {
    init(clientModels: [TeamInfoClientModel]) {
        self.init(
            title: "Select a team",
            teamModels: clientModels.map { TeamThumbnailViewModel(clientModel: $0) }
        )
    }
}

extension TeamThumbnailViewModel {
    init(clientModel: TeamInfoClientModel) {
        self.init(
            teamInfoId: clientModel.id,
            text: clientModel.city + " " + clientModel.teamName
        )
    }
}

#if DEBUG
class MockTeamSelectInteractor: TeamSelectInteractorProtocol {
    var mockTeamModels: [TeamThumbnailViewModel] = [
        TeamThumbnailViewModel(teamInfoId: "1", text: "Team A"),
        TeamThumbnailViewModel(teamInfoId: "2", text: "Team B"),
        TeamThumbnailViewModel(teamInfoId: "3", text: "Team C")
    ]
    var viewModel: TeamSelectViewModel {
        TeamSelectViewModel(title: "Select a team", teamModels: mockTeamModels)
    }
    var eventBus: TeamSelectEventBus = TeamSelectEventBus()
}
#endif
