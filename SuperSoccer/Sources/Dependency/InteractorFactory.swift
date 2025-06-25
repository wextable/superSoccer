//
//  InteractorFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 6/24/25.
//

import Foundation

// MARK: - InteractorFactory Protocol

protocol InteractorFactoryProtocol {
    // Simple interactors (no extra params)
    func makeNewGameInteractor() -> NewGameInteractorProtocol
    func makeMainMenuInteractor() -> MainMenuInteractorProtocol
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol
    
    // Parameterized interactors
    func makeTeamInteractor(userTeamId: String) -> TeamInteractorProtocol
    
    // Future parameterized interactors would follow this pattern:
    // func makePlayerInteractor(playerId: String, teamId: String) -> PlayerInteractorProtocol
    // func makeMatchInteractor(matchId: String) -> MatchInteractorProtocol
}

// MARK: - InteractorFactory Implementation

final class InteractorFactory: InteractorFactoryProtocol {
    private let dataManager: DataManagerProtocol
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
    }
    
    func makeNewGameInteractor() -> NewGameInteractorProtocol {
        return NewGameInteractor(dataManager: dataManager)
    }
    
    func makeMainMenuInteractor() -> MainMenuInteractorProtocol {
        return MainMenuInteractor(dataManager: dataManager)
    }
    
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol {
        return TeamSelectInteractor(dataManager: dataManager)
    }
    
    func makeTeamInteractor(userTeamId: String) -> TeamInteractorProtocol {
        return TeamInteractor(userTeamId: userTeamId, dataManager: dataManager)
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
class MockInteractorFactory: InteractorFactoryProtocol {
    // Pre-configured mocks for simple interactors
    let mockNewGameInteractor = MockNewGameInteractor()
    let mockMainMenuInteractor = MockMainMenuInteractor()
    let mockTeamSelectInteractor = MockTeamSelectInteractor()
    
    init() {
        setupDefaultMockBehaviors()
    }
    
    func makeNewGameInteractor() -> NewGameInteractorProtocol {
        return mockNewGameInteractor
    }
    
    func makeMainMenuInteractor() -> MainMenuInteractorProtocol {
        return mockMainMenuInteractor
    }
    
    func makeTeamSelectInteractor() -> TeamSelectInteractorProtocol {
        return mockTeamSelectInteractor
    }
    
    func makeTeamInteractor(userTeamId: String) -> TeamInteractorProtocol {
        return MockTeamInteractor()
    }
    
    private func setupDefaultMockBehaviors() {
        // Configure common test scenarios  
        // Note: viewModel properties are @Published, so they're set up in the mock initializers
    }
}
#endif 
