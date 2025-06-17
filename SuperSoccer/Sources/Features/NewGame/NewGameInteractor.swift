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

protocol NewGameInteractorDelegate: AnyObject {
    func interactorDidRequestTeamSelection()
    func interactorDidCreateGame(with result: CreateNewCareerResult)
    func interactorDidCancel()
}

protocol NewGameInteractorProtocol: AnyObject {
    var viewModel: NewGameViewModel { get }
    var eventBus: NewGameEventBus { get }
    var delegate: NewGameInteractorDelegate? { get set }
    func bindFirstName() -> Binding<String>
    func bindLastName() -> Binding<String>
    func updateSelectedTeam(_ teamInfo: TeamInfo)
}

@Observable
final class NewGameInteractor: NewGameInteractorProtocol {
    private let dataManager: DataManagerProtocol
    private let localDataSource: NewGameLocalDataSourceProtocol
    let eventBus = NewGameEventBus()
    
    weak var delegate: NewGameInteractorDelegate?
    
    var viewModel: NewGameViewModel = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(
        dataManager: DataManagerProtocol,
        localDataSource: NewGameLocalDataSourceProtocol = NewGameLocalDataSource()
    ) {
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
                    delegate?.interactorDidRequestTeamSelection()
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
    
    func updateSelectedTeam(_ teamInfo: TeamInfo) {
        localDataSource.updateSelectedTeam(teamInfo)
    }
    
    private func createViewModel(localData: NewGameLocalDataSource.Data) -> NewGameViewModel {
        return NewGameViewModel(
            title: "New game",
            coachLabelText: "Coach",
            coachFirstNameLabel: "First name",
            coachFirstName: localData.coachFirstName,
            coachLastNameLabel: "Last name",
            coachLastName: localData.coachLastName,
            teamSelectorModel: TeamSelectorViewModel(
                title: localData.selectedTeamInfo?.city ?? "Team:",
                buttonTitle: localData.selectedTeamInfo?.teamName ?? "Select your team",
                action: { [weak self] in
                    self?.eventBus.send(.teamSelectorTapped)
                }
            ),
            buttonText: "Start game",
            submitEnabled: localData.isValid
        )
    }
    
    func createGame() async {
        guard localDataSource.data.isValid,
              let teamInfo = localDataSource.data.selectedTeamInfo else {
            return
        }
        
        let request = CreateNewCareerRequest(
            coachFirstName: localDataSource.data.coachFirstName,
            coachLastName: localDataSource.data.coachLastName,
            selectedTeamInfoId: teamInfo.id,
            leagueName: "Premier League", // Default league name
            seasonYear: 2025
        )
        
        do {
            let result = try await dataManager.createNewCareer(request)
            print("Career created successfully: \(result.careerId)")
            
            // Ensure delegate call happens on main thread for UI updates and testing
            await MainActor.run {
                delegate?.interactorDidCreateGame(with: result)
            }
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
    }
}

class MockNewGameInteractor: NewGameInteractorProtocol {
    var viewModel: NewGameViewModel = .make()
    var eventBus: NewGameEventBus = NewGameEventBus()
    weak var delegate: NewGameInteractorDelegate?
    
    func bindFirstName() -> Binding<String> {
        .constant("")
    }
    
    func bindLastName() -> Binding<String> {
        .constant("")
    }
    
    func updateSelectedTeam(_ teamInfo: TeamInfo) {
        // Mock implementation
    }
}

class MockNewGameInteractorDelegate: NewGameInteractorDelegate {
    var didRequestTeamSelection = false
    var onDidRequestTeamSelection: (() -> Void)?
    func interactorDidRequestTeamSelection() {
        didRequestTeamSelection = true
        onDidRequestTeamSelection?()
    }
    
    var didCreateGameCalled = false
    var lastCreateGameResult: CreateNewCareerResult?
    var onDidCreateGame: (() -> Void)?
    func interactorDidCreateGame(with result: CreateNewCareerResult) {
        didCreateGameCalled = true
        lastCreateGameResult = result
        onDidCreateGame?()
    }
    
    var didCancelCalled = false
    var onDidCancel: (() -> Void)?
    func interactorDidCancel() {
        didCancelCalled = true
        onDidCancel?()
    }
}
#endif
