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
    let eventBus = NewGameEventBus()
    
    var viewModel: NewGameViewModel = .init()
    private var cancellables = Set<AnyCancellable>()
    
    init(newGameCoordinator: NewGameFeatureCoordinatorProtocol) {
        self.newGameCoordinator = newGameCoordinator
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        eventBus
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .submitTapped:
                    Task {
                        await self.newGameCoordinator.createGame()
                    }
                case .teamSelectorTapped:
                    self.newGameCoordinator.startTeamSelection()
                }
            }
            .store(in: &cancellables)
        
        newGameCoordinator.statePublisher
            .sink { [weak self] state in
                guard let self else { return }
                self.viewModel = self.createViewModel(from: state)
            }
            .store(in: &cancellables)
    }
    
    func bindFirstName() -> Binding<String> {
        Binding(
            get: { self.viewModel.coachFirstName },
            set: { newValue in
                self.viewModel.coachFirstName = newValue
                self.newGameCoordinator.updateCoachInfo(
                    firstName: newValue,
                    lastName: self.viewModel.coachLastName
                )
            }
        )
    }
    
    func bindLastName() -> Binding<String> {
        Binding(
            get: { self.viewModel.coachLastName },
            set: { newValue in
                self.viewModel.coachLastName = newValue
                self.newGameCoordinator.updateCoachInfo(
                    firstName: self.viewModel.coachFirstName,
                    lastName: newValue
                )
            }
        )
    }
    
    private func createViewModel(from state: NewGameState) -> NewGameViewModel {
        return NewGameViewModel(
            title: "New Game",
            coachLabelText: "Coach name",
            coachFirstNameLabel: "First name",
            coachFirstName: state.coachInfo?.firstName ?? "",
            coachLastNameLabel: "Last name",
            coachLastName: state.coachInfo?.lastName ?? "",
            teamSelectorModel: TeamSelectorViewModel(
                clientModel: state.selectedTeam,
                action: { [weak self] in
                    self?.eventBus.send(.teamSelectorTapped)
                }
            ),
            buttonText: "Start Game",
            submitEnabled: state.coachInfo != nil && state.selectedTeam != nil
        )
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
