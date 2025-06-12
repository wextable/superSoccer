//
//  TeamSelectInteractor.swift
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
    private let featureCoordinator: TeamSelectFeatureCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    let eventBus = TeamSelectEventBus()
    
    private let teamInfos: [TeamInfo]
    var viewModel: TeamSelectViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(
        featureCoordinator: TeamSelectFeatureCoordinatorProtocol,
        dataManager: DataManagerProtocol
    ) {
        self.featureCoordinator = featureCoordinator
        self.dataManager = dataManager
        
        teamInfos = dataManager.fetchTeamInfos()
        let teamModels = teamInfos.map {
            TeamThumbnailViewModel(
                id: $0.id,
                text: "\($0.city) \($0.teamName)"
            )
        }
        viewModel = TeamSelectViewModel(
            title: "Select a team",
            teamModels: teamModels
        )
        
        setupSubscriptions()
        
    }
    
    private func setupSubscriptions() {
        subscribeToEvents()
    }
    
    private func subscribeToEvents() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .teamSelected(let teamInfoId):
                    self?.handleTeamSelected(teamInfoId: teamInfoId)
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleTeamSelected(teamInfoId: String) {
        guard let teamInfo = teamInfos.first(where: { $0.id == teamInfoId }) else { return }
        featureCoordinator.handleTeamSelected(teamInfo)
    }
}

#if DEBUG
extension TeamSelectInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: TeamSelectInteractor
        
        var featureCoordinator: TeamSelectFeatureCoordinatorProtocol { target.featureCoordinator }
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
