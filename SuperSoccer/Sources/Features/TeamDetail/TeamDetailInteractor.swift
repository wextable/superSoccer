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
    private let router: NavigationRouter
    private let teamId: String
    private let dataManager: DataManager
    let eventBus = TeamDetailEventBus()
    
    var viewModel: TeamDetailViewModel = .init(title: "Your fucking team", teamName: "Your team name!")
    
    private var clientModels: [TeamInfoClientModel] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(router: NavigationRouter, teamId: String, dataManager: DataManager) {
        self.router = router
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
                teams.first(where: { $0.info.id == self?.teamId })
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

extension TeamDetailViewModel {
    init(clientModel: TeamClientModel) {
        self.init(
            title: "Your fucking team:",
            teamName: clientModel.info.city + " " + clientModel.info.teamName
        )
    }
}
