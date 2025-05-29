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
    case teamSelected(teamId: String)
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
    
    var viewModel: TeamSelectViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(
        featureCoordinator: TeamSelectFeatureCoordinatorProtocol,
        dataManager: DataManagerProtocol
    ) {
        self.featureCoordinator = featureCoordinator
        self.dataManager = dataManager
        self.viewModel = Self.createViewModel(from: featureCoordinator.state)
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        subscribeToEvents()
        subscribeToStateChanges()
    }
    
    private func subscribeToStateChanges() {
        featureCoordinator.statePublisher
            .sink { [weak self] state in
                self?.viewModel = Self.createViewModel(from: state)
            }
            .store(in: &cancellables)
    }
    
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
        guard let teamInfo = featureCoordinator.state.teams.first(where: { $0.id == teamId }) else { return }
        featureCoordinator.handleTeamSelected(teamInfo)
    }
    
    private static func createViewModel(from state: TeamSelectState) -> TeamSelectViewModel {
        let teamModels = state.teams.map { teamInfo in
            TeamThumbnailViewModel(
                id: teamInfo.id,
                text: "\(teamInfo.city) \(teamInfo.teamName)"
            )
        }
        
        return TeamSelectViewModel(
            title: "Select a team",
            teamModels: teamModels
        )
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
