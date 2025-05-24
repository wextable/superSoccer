//
//  MainMenuInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Testing
import Combine
@testable import SuperSoccer

struct MainMenuViewInteractorTests {
    @Test func testInitialViewModel() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        
        // Act
        let interactor = MainMenuInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Assert initial state
        #expect(interactor.viewModel.title == "Main menu")
        #expect(interactor.viewModel.menuItemModels.count == 1)
        #expect(interactor.viewModel.menuItemModels[0].title == "New Game")
    }
    
    @Test func testNewGameSelectionNavigatesToTeamSelect() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let interactor = MainMenuInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Act
        interactor.eventBus.send(.newGameSelected)
        
        // Assert
        #expect(mockNavigationCoordinator.screenNavigatedTo == .teamSelect)
    }
    
    @Test func testDependencyInjection() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        
        // Act
        let interactor = MainMenuInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Assert dependencies were correctly injected
        #expect(interactor.testHooks.navigationCoordinator as? MockNavigationCoordinator === mockNavigationCoordinator)
        #expect(interactor.testHooks.dataManager as? MockDataManager === mockDataManager)
    }
}
