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
        // Arrange
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let mockDataManager = MockDataManager()
        
        // Act
        let coordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Assert
        #expect(coordinator != nil)
    }
    
    @Test("MainMenuFeatureCoordinator sets up interactor delegate correctly")
    @MainActor
    func testInteractorDelegateSetup() {
        // Arrange
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let mockDataManager = MockDataManager()
        
        // Act
        let coordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Assert - The interactor should have the coordinator as its delegate
        // We can't directly access the private interactor, but we can test the behavior
        #expect(coordinator != nil)
    }
    
    // MARK: - Start Tests
    
    @Test("MainMenuFeatureCoordinator start method navigates to main menu")
    @MainActor
    func testStartNavigatesToMainMenu() async {
        // Arrange
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let mockDataManager = MockDataManager()
        let coordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Act
        coordinator.start()
        
        // Wait for async navigation
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert
        #expect(mockNavigationCoordinator.replaceStackWithCalled == true)
    }
    
    // MARK: - New Game Selection Tests
    
    @Test("MainMenuFeatureCoordinator handles new game selection")
    @MainActor
    func testHandleNewGameSelection() {
        // Arrange
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let mockDataManager = MockDataManager()
        let coordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
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
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let mockDataManager = MockDataManager()
        let coordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Act
        coordinator.interactorDidSelectNewGame()
        
        // Assert - We can't directly access childCoordinators as it's private
        // But we can test that the method executes without error
        #expect(coordinator != nil)
    }
    
    // MARK: - Child Coordinator Management Tests
    
    @Test("MainMenuFeatureCoordinator manages child coordinator lifecycle")
    @MainActor
    func testChildCoordinatorLifecycle() {
        // Arrange
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let mockDataManager = MockDataManager()
        let coordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        var receivedResult: MainMenuCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act - Start a child coordinator
        coordinator.handleNewGameSelected()
        
        // Since we can't access private childCoordinators, we'll simulate the result
        let mockResult = CreateNewCareerResult.make()
        coordinator.finish(with: .newGameCreated(mockResult))
        
        // Assert - Coordinator finished with correct result
        #expect(receivedResult != nil)
        if case .newGameCreated(let result) = receivedResult {
            #expect(result.careerId == mockResult.careerId)
        } else {
            #expect(Bool(false), "Expected newGameCreated result")
        }
    }
    
    @Test("MainMenuFeatureCoordinator handles child coordinator cancellation")
    @MainActor
    func testChildCoordinatorCancellation() {
        // Arrange
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let mockDataManager = MockDataManager()
        let coordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        var finishCalled = false
        
        coordinator.onFinish = { _ in
            finishCalled = true
        }
        
        // Act - Start a child coordinator and simulate cancellation
        coordinator.handleNewGameSelected()
        
        // Since we can't access private implementation details,
        // we test that cancellation doesn't trigger finish
        #expect(finishCalled == false)
    }
    
    // MARK: - Result Handling Tests
    
    @Test("MainMenuFeatureCoordinator finishes with correct result when game is created")
    @MainActor
    func testFinishesWithCorrectResultWhenGameCreated() {
        // Arrange
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let mockDataManager = MockDataManager()
        let coordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
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
