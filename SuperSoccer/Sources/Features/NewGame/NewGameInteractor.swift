//
//  NewGameInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

import Combine
import Observation
import SwiftUI

typealias NewGameEventBus = PassthroughSubject<NewGameEvent, Never>

enum NewGameEvent: BusEvent {
    case submitTapped
    case teamSelectorTapped
}

protocol NewGameInteractorProtocol: AnyObject {
    var viewModel: NewGameViewModel { get }
    var eventBus: NewGameEventBus { get }
    func bindFirstName() -> Binding<String>
    func bindLastName() -> Binding<String>
}

@Observable
final class NewGameInteractor: NewGameInteractorProtocol {
    private let newGameCoordinator: NewGameFeatureCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    private let localDataSource: NewGameLocalDataSourceProtocol
    let eventBus = NewGameEventBus()
    
    var viewModel: NewGameViewModel = .init()
    private var cancellables = Set<AnyCancellable>()
    
    private var coachFirstName: String = ""
    private var coachLastName: String = ""
    private var selectedTeamInfo: TeamInfo?
    
    init(
        newGameCoordinator: NewGameFeatureCoordinatorProtocol,
        dataManager: DataManagerProtocol,
        localDataSource: NewGameLocalDataSourceProtocol = NewGameLocalDataSource()
    ) {
        self.newGameCoordinator = newGameCoordinator
        self.dataManager = dataManager
        self.localDataSource = localDataSource
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        subscribeToDataSources()
        subscribeToUIEvents()
    }
    
    private func subscribeToDataSources() {
        localDataSource.dataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.viewModel = createViewModel(localData: data)
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToUIEvents() {
        eventBus
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .submitTapped:
                    Task {
                        await self.createGame()
                    }
                case .teamSelectorTapped:
                    self.newGameCoordinator.startTeamSelection()
                }
            }
            .store(in: &cancellables)
    }
    
    func bindFirstName() -> Binding<String> {
        Binding(
            get: { self.viewModel.coachFirstName },
            set: { newValue in
                self.localDataSource.updateCoach(firstName: newValue)
            }
        )
    }
    
    func bindLastName() -> Binding<String> {
        Binding(
            get: { self.viewModel.coachLastName },
            set: { newValue in
                self.localDataSource.updateCoach(lastName: newValue)
            }
        )
    }
    
    private func createViewModel(localData: NewGameLocalDataSource.Data) -> NewGameViewModel {
        return NewGameViewModel(
            title: "New Game",
            coachLabelText: "Coach name",
            coachFirstNameLabel: "First name",
            coachFirstName: localData.coachFirstName,
            coachLastNameLabel: "Last name",
            coachLastName: localData.coachLastName,
            teamSelectorModel: TeamSelectorViewModel(
                clientModel: localData.selectedTeamInfo,
                action: { [weak self] in
                    self?.eventBus.send(.teamSelectorTapped)
                }
            ),
            buttonText: "Start Game",
            submitEnabled: localData.isValid
        )
    }
    
    func createGame() async {
        guard let teamInfo = selectedTeamInfo,
              !coachFirstName.isEmpty,
              !coachLastName.isEmpty else { return }
        
        let request = CreateNewCareerRequest(
            coachFirstName: coachFirstName,
            coachLastName: coachLastName,
            selectedTeamInfoId: teamInfo.id,
            leagueName: "Premier League", // Default league name
            seasonYear: 2025
        )
        
        do {
            let result = try await dataManager.createNewCareer(request)
            print("Career created successfully: \(result.careerId)")
//            finish(with: .gameCreated(result))
        } catch {
            print("Error creating career: \(error)")
            // TODO: Handle error appropriately
        }
    }
}

#if DEBUG
extension NewGameInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: NewGameInteractor
        
        var newGameCoordinator: NewGameFeatureCoordinatorProtocol { target.newGameCoordinator }
    }
}

class MockNewGameInteractor: NewGameInteractorProtocol {
    var viewModel: NewGameViewModel = .make()
    var eventBus: NewGameEventBus = NewGameEventBus()
    
    func bindFirstName() -> Binding<String> {
        .constant("")
    }
    
    func bindLastName() -> Binding<String> {
        .constant("")
    }
}
#endif
