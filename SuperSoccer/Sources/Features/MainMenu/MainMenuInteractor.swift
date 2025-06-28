//
//  MainMenuInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//
import Foundation
import Combine
import Observation

// MARK: - Protocol Separation (following NewGame pattern)

protocol MainMenuBusinessLogicDelegate: AnyObject {
    func businessLogicDidSelectNewGame()
}

protocol MainMenuBusinessLogic: AnyObject {
    var delegate: MainMenuBusinessLogicDelegate? { get set }
}

protocol MainMenuInteractorProtocol: MainMenuBusinessLogic & MainMenuViewPresenter {}

// MARK: - Implementation

@Observable
final class MainMenuInteractor: MainMenuInteractorProtocol {
    private let dataManager: DataManagerProtocol
    private let mainMenuViewModelTransform: MainMenuViewModelTransformProtocol
    
    weak var delegate: MainMenuBusinessLogicDelegate?
    var viewModel: MainMenuViewModel = .init(title: "Main menu", menuItemModels: [])
    
    private var cancellables = Set<AnyCancellable>()
    
    init(dataManager: DataManagerProtocol,
         mainMenuViewModelTransform: MainMenuViewModelTransformProtocol = MainMenuViewModelTransform()) {
        self.dataManager = dataManager
        self.mainMenuViewModelTransform = mainMenuViewModelTransform
        
        setupInitialViewModel()
        setupSubscriptions()
    }
    
    private func setupInitialViewModel() {
        // TODO: Check for existing careers from data manager
        let hasExistingCareers = false // Placeholder
        
        self.viewModel = mainMenuViewModelTransform.transform(
            hasExistingCareers: hasExistingCareers,
            onNewGameTapped: { [weak self] in
                self?.newGameTapped()
            }
        )
    }
    
    private func setupSubscriptions() {
        subscribeToDataSource()
    }
    
    private func subscribeToDataSource() {
        // TODO: Subscribe to career changes to update hasExistingCareers
        // When we implement career persistence, we'll subscribe to career publisher
        // and update the view model when careers are created/deleted
    }
    
    // MARK: - MainMenuViewPresenter
    
    func newGameTapped() {
        delegate?.businessLogicDidSelectNewGame()
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension MainMenuInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: MainMenuInteractor
        
        var dataManager: DataManagerProtocol { target.dataManager }
    }
}

class MockMainMenuInteractor: MainMenuInteractorProtocol {
    weak var delegate: MainMenuBusinessLogicDelegate?
    var viewModel: MainMenuViewModel {
        MainMenuViewModel(
            title: "Main menu",
            menuItemModels: [
                .init(title: "New game") {}
            ])
    }
    
    // Test tracking properties
    var newGameTappedCalled = false
    var onNewGameTapped: (() -> Void)?
    
    func newGameTapped() {
        newGameTappedCalled = true
        onNewGameTapped?()
        delegate?.businessLogicDidSelectNewGame()
    }
}

class MockMainMenuInteractorDelegate: MainMenuBusinessLogicDelegate {
    var didSelectNewGameCalled = false
    var onDidSelectNewGame: (() -> Void)?
    
    func businessLogicDidSelectNewGame() {
        didSelectNewGameCalled = true
        onDidSelectNewGame?()
    }
}
#endif
