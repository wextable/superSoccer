//
//  TeamDetailInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Combine
import Observation

typealias TeamDetailEventBus = PassthroughSubject<TeamDetailEvent, Never>

enum TeamDetailEvent: BusEvent {
    case mockEvent
}

protocol TeamDetailInteractorProtocol: AnyObject {
    var viewModel: TeamDetailViewModel { get }
    var eventBus: TeamDetailEventBus { get }
}
    
@Observable
final class TeamDetailInteractor: TeamDetailInteractorProtocol {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let teamId: String
    private let dataManager: DataManagerProtocol
    let eventBus = TeamDetailEventBus()
    
    var viewModel: TeamDetailViewModel = .init(title: "Team Details", teamName: "Loading...")
    
    private var clientModels: [TeamInfo] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, teamId: String, dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.teamId = teamId
        self.dataManager = dataManager
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        subscribeToDataSource()
        subscribeToEvents()
    }
    
    private func subscribeToDataSource() {
        dataManager.teamPublisher
            .compactMap { [weak self] teams in
                teams.first(where: { $0.id == self?.teamId })
            }
            .sink { [weak self] team in
                guard let self else { return }
                self.viewModel = TeamDetailViewModel(clientModel: team)
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToEvents() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .mockEvent:
                    self?.handleMockEvent()
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleMockEvent() {
        print("mockypoo")
    }
}

#if DEBUG
extension TeamDetailInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: TeamDetailInteractor
        
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var dataManager: DataManagerProtocol { target.dataManager }
        var teamId: String { target.teamId }
    }
}

class MockTeamDetailInteractor: TeamDetailInteractorProtocol {
    var viewModel: TeamDetailViewModel = TeamDetailViewModel.make()
    var eventBus: TeamDetailEventBus = TeamDetailEventBus()
}
#endif
