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
}

protocol NewGameInteractorProtocol: AnyObject {
    var viewModel: NewGameViewModel { get }
    var eventBus: NewGameEventBus { get }
    func bindFirstName() -> Binding<String>
    func bindLastName() -> Binding<String>
}

@Observable
final class NewGameInteractor: NewGameInteractorProtocol {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    let eventBus = NewGameEventBus()
    
    var viewModel: NewGameViewModel
    var selectedTeam: TeamInfo? {
        didSet {
            viewModel.teamSelectorModel = teamSelectorViewModel()
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        
        self.viewModel = NewGameViewModel(
            title: "New game",
            coachLabelText: "Coach name",
            coachFirstNameLabel: "First name",
            coachFirstName: "",
            coachLastNameLabel: "Last name",
            coachLastName: "",
            teamSelectorModel: TeamSelectorViewModel(
                clientModel: nil,
                action: {}
            ),
            buttonText: "Start game",
            submitEnabled: false
        )
        viewModel.teamSelectorModel = teamSelectorViewModel()
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .submitTapped:
                    self?.handleSubmit()
                }
            }
            .store(in: &cancellables)
    }
    
    func bindFirstName() -> Binding<String> {
        Binding(
            get: { self.viewModel.coachFirstName },
            set: { newValue in
                self.viewModel.coachFirstName = newValue
                self.updateSubmitEnabled()
            }
        )
    }
    
    func bindLastName() -> Binding<String> {
        Binding(
            get: { self.viewModel.coachLastName },
            set: { newValue in
                self.viewModel.coachLastName = newValue
                self.updateSubmitEnabled()
            }
        )
    }
    
    private func updateSubmitEnabled() {
        viewModel.submitEnabled = !viewModel.coachFirstName.isEmpty && !viewModel.coachLastName.isEmpty
    }
    
    private func teamSelectorViewModel() -> TeamSelectorViewModel {
        TeamSelectorViewModel(
            clientModel: selectedTeam,
            action: { [weak self] in
                self?.selectTeam()
            }
        )
    }
    
    private func selectTeam() {
        navigationCoordinator.presentSheet(
            .teamSelect { [weak self] teamInfo in
                guard let self else {
                    return
                }
                self.selectedTeam = teamInfo
                self.viewModel.teamSelectorModel = self.teamSelectorViewModel()
            }
        )
    }
    
    private func handleSubmit() {
//        let coach = Coach(
//            id: UUID().uuidString,
//            firstName: viewModel.coachFirstName,
//            lastName: viewModel.coachLastName
//        )
//        navigationCoordinator.navigateToScreen(.teamSelect)
    }
}

#if DEBUG
extension NewGameInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: NewGameInteractor
        
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var dataManager: DataManagerProtocol { target.dataManager }
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
