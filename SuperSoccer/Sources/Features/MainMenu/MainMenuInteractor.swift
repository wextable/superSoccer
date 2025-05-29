//
//  MainMenuInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import Combine
import Observation

typealias MainMenuEventBus = PassthroughSubject<MainMenuEvent, Never>

enum MainMenuEvent: BusEvent {
    case newGameSelected
}

protocol MainMenuInteractorProtocol: AnyObject {
    var viewModel: MainMenuViewModel { get }
    var eventBus: MainMenuEventBus { get }
}
    
@Observable
final class MainMenuInteractor: MainMenuInteractorProtocol {
    private let featureCoordinator: MainMenuFeatureCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    let eventBus = MainMenuEventBus()
    
    var viewModel: MainMenuViewModel = .init(title: "Main menu", menuItemModels: [])
    
//    private var clientModels: [TeamInfo] = []
    private var cancellables = Set<AnyCancellable>()
    
    init(featureCoordinator: MainMenuFeatureCoordinatorProtocol, dataManager: DataManagerProtocol) {
        self.featureCoordinator = featureCoordinator
        self.dataManager = dataManager
        
        self.viewModel = MainMenuViewModel(
            title: "Main menu",
            menuItemModels: [
                .init(title: "New Game") {
                    self.eventBus.send(.newGameSelected)
                }
            ]
        )
        
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        subscribeToDataSource()
        subscribeToEvents()
    }
    
    private func subscribeToDataSource() {
        // TODO: see if we have any saved games, if so add a load game button
        dataManager.teamPublisher
            .sink { _ in // [weak self] teams in
//                guard let self else { return }
//                self.viewModel = TeamSelectViewModel(clientModels: teams.map(\.info))
            }
            .store(in: &cancellables)
    }
    
    private func subscribeToEvents() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .newGameSelected:
                    self?.handleNewGameSelected()
                }
            }
            .store(in: &cancellables)
    }
    
    private func handleNewGameSelected() {
        featureCoordinator.handleNewGameSelected()
    }
}

#if DEBUG
extension MainMenuInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: MainMenuInteractor
        
        var featureCoordinator: MainMenuFeatureCoordinatorProtocol { target.featureCoordinator }
        var dataManager: DataManagerProtocol { target.dataManager }
    }
}

class MockMainMenuInteractor: MainMenuInteractorProtocol {
    var viewModel: MainMenuViewModel {
        MainMenuViewModel(
            title: "Main menu",
            menuItemModels: [
                .init(title: "New Game") {}
            ])
    }
    
    var eventBus: MainMenuEventBus = MainMenuEventBus()
}
#endif
