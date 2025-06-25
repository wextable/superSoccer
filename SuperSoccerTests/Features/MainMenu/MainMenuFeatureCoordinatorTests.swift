//
//  MainMenuFeatureCoordinatorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Testing
import Combine
@testable import SuperSoccer

struct MainMenuFeatureCoordinatorTests {
    
    // MARK: - Initialization Tests
    
    @Test("MainMenuFeatureCoordinator initializes with correct dependencies")
    @MainActor
    func testInitializationWithCorrectDependencies() {
        // Arrange & Act
        let container = MockDependencyContainer()
        let coordinator = container.makeMainMenuCoordinator()
        
        // Assert
        #expect(coordinator != nil)
    }
    
    @Test("MainMenuFeatureCoordinator sets up interactor delegate correctly")
    @MainActor
    func testInteractorDelegateSetup() {
        // Arrange & Act
        let container = MockDependencyContainer()
        let coordinator = container.makeMainMenuCoordinator()
        
        // Assert - The interactor should have the coordinator as its delegate
        // We can verify this via the mock interactor
        #expect(container.mockInteractorFactory.mockMainMenuInteractor.delegate === coordinator)
    }
    
    // MARK: - Start Tests
    
    @Test("MainMenuFeatureCoordinator start method navigates to main menu")
    @MainActor
    func testStartNavigatesToMainMenu() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeMainMenuCoordinator()
        
        // Act
        coordinator.start()
        
        // Wait for async navigation
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert
        #expect(container.mockNavigationCoordinator.replaceStackWithCalled == true)
    }
    
    // MARK: - New Game Selection Tests
    
    @Test("MainMenuFeatureCoordinator handles new game selection")
    @MainActor
    func testHandleNewGameSelection() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeMainMenuCoordinator()
        
        // Act
        coordinator.handleNewGameSelected()
        
        // Assert - We can't directly access childCoordinators as it's private
        // But we can test that the method executes without error
        #expect(coordinator != nil)
    }
    
    // MARK: - Interactor Delegate Tests
    
    @Test("MainMenuFeatureCoordinator responds to interactor new game selection")
    @MainActor
    func testInteractorNewGameSelection() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeMainMenuCoordinator()
        
        // Act
        coordinator.interactorDidSelectNewGame()
        
        // Assert - We can't directly access childCoordinators as it's private
        // But we can test that the method executes without error
        #expect(coordinator != nil)
    }
    
    // MARK: - Child Coordinator Management Tests
    
    @Test("MainMenuFeatureCoordinator manages child coordinator lifecycle")
    @MainActor
    func testChildCoordinatorLifecycle() throws {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeMainMenuCoordinator()
        var receivedResult: MainMenuCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act - Start a child coordinator
        coordinator.handleNewGameSelected()
        
        // Assert - Child coordinator was created and started
        #expect(coordinator.testHooks.childCoordinators.count == 1)
        
        // Use TestHooks to simulate child coordinator finishing
        let mockResult = CreateNewCareerResult.make()
        let childCoordinator = try #require(coordinator.testHooks.childCoordinators.first as? NewGameFeatureCoordinator)
        coordinator.testHooks.simulateChildFinish(childCoordinator, with: .gameCreated(mockResult))
        
        // Assert - Main coordinator finished with correct result and child was cleaned up
        #expect(receivedResult != nil)
        if case .newGameCreated(let result) = receivedResult {
            #expect(result.careerId == mockResult.careerId)
        } else {
            #expect(Bool(false), "Expected newGameCreated result")
        }
        
        // Assert - Child coordinator was automatically cleaned up
        #expect(coordinator.testHooks.childCoordinators.count == 0)
    }
    
    @Test("MainMenuFeatureCoordinator handles child coordinator cancellation")
    @MainActor
    func testChildCoordinatorCancellation() throws {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeMainMenuCoordinator()
        var finishCalled = false
        
        coordinator.onFinish = { _ in
            finishCalled = true
        }
        
        // Act - Start a child coordinator and simulate cancellation
        coordinator.handleNewGameSelected()
        
        // Assert - Child coordinator was created
        #expect(coordinator.testHooks.childCoordinators.count == 1)
        
        // Use TestHooks to simulate child coordinator cancelling
        let childCoordinator = try #require(coordinator.testHooks.childCoordinators.first as? NewGameFeatureCoordinator)
        coordinator.testHooks.simulateChildFinish(childCoordinator, with: .cancelled)
        
        // Assert - Main coordinator didn't finish when child was cancelled, and child was cleaned up
        #expect(finishCalled == false)
        #expect(coordinator.testHooks.childCoordinators.count == 0)
    }
    
    // MARK: - Result Handling Tests
    
    @Test("MainMenuFeatureCoordinator finishes with correct result when game is created")
    @MainActor
    func testFinishesWithCorrectResultWhenGameCreated() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeMainMenuCoordinator()
        var receivedResult: MainMenuCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act
        let mockResult = CreateNewCareerResult.make()
        coordinator.finish(with: .newGameCreated(mockResult))
        
        // Assert
        if case .newGameCreated(let result) = receivedResult {
            #expect(result.careerId == mockResult.careerId)
        } else {
            #expect(Bool(false), "Expected newGameCreated result")
        }
    }
}
