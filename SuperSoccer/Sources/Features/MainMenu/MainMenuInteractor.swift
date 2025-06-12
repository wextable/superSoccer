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

protocol MainMenuInteractorDelegate: AnyObject {
    func interactorDidSelectNewGame()
}

protocol MainMenuInteractorProtocol: AnyObject {
    var viewModel: MainMenuViewModel { get }
    var eventBus: MainMenuEventBus { get }
    var delegate: MainMenuInteractorDelegate? { get set }
}
    
@Observable
final class MainMenuInteractor: MainMenuInteractorProtocol {
    private let dataManager: DataManagerProtocol
    let eventBus = MainMenuEventBus()
    var viewModel: MainMenuViewModel = .init(title: "Main menu", menuItemModels: [])
    weak var delegate: MainMenuInteractorDelegate?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(dataManager: DataManagerProtocol) {
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
        delegate?.interactorDidSelectNewGame()
    }
}

#if DEBUG
extension MainMenuInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: MainMenuInteractor
        
        var dataManager: DataManagerProtocol { target.dataManager }
    }
}

class MockMainMenuInteractor: MainMenuInteractorProtocol {
    weak var delegate: MainMenuInteractorDelegate?
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
