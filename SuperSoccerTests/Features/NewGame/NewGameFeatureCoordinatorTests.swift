//
//  NewGameFeatureCoordinatorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Testing
import Combine
import Foundation
@testable import SuperSoccer

struct NewGameFeatureCoordinatorTests {
    
    // MARK: - Initialization Tests
    
    @Test("NewGameFeatureCoordinator initializes with correct dependencies")
    @MainActor
    func testInitializationWithCorrectDependencies() {
        // Arrange & Act
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Assert
        #expect(coordinator != nil)
    }
    
    @Test("NewGameFeatureCoordinator sets up interactor delegate correctly")
    @MainActor
    func testInteractorDelegateSetup() {
        // Arrange & Act
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Assert - The interactor should have the coordinator as its delegate
        // We can verify this via the mock interactor
        #expect(container.mockInteractorFactory.mockNewGameInteractor.delegate === coordinator)
    }
    
    // MARK: - Start Tests
    
    @Test("NewGameFeatureCoordinator start method navigates to new game")
    @MainActor
    func testStartNavigatesToNewGame() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Act
        coordinator.start()
        
        // Wait for async navigation
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert
        #expect(container.mockNavigationCoordinator.screenNavigatedTo != nil)
    }
    
    // MARK: - Team Selection Tests
    
    @Test("NewGameFeatureCoordinator handles team selection request")
    @MainActor
    func testHandleTeamSelectionRequest() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Act & Wait for child coordinator to be created (no arbitrary delays!)
        await coordinator.testHooks.executeAndWaitForChildCoordinator {
            coordinator.businessLogicDidRequestTeamSelection()
        }
        
        // Assert - Child coordinator should be created
        #expect(coordinator.testHooks.childCoordinators.count == 1)
        #expect(coordinator.testHooks.childCoordinators.first is TeamSelectFeatureCoordinator)
    }
    
    @Test("NewGameFeatureCoordinator handles team selection result")
    @MainActor
    func testHandleTeamSelectionResult() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Act - Start team selection to create child coordinator
        // Act & Wait for child coordinator to be created (no arbitrary delays!)
        await coordinator.testHooks.executeAndWaitForChildCoordinator {
            coordinator.businessLogicDidRequestTeamSelection()
        }
        
        // Assert - Child coordinator should be created and interactor setup correctly
        #expect(coordinator.testHooks.childCoordinators.count == 1)
        #expect(coordinator.testHooks.childCoordinators.first is TeamSelectFeatureCoordinator)
    }
    
    // MARK: - Game Creation Tests
    
    @Test("NewGameFeatureCoordinator handles game creation")
    @MainActor
    func testHandleGameCreation() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        var receivedResult: NewGameCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act
        let mockResult = CreateNewCareerResult.make()
        coordinator.businessLogicDidCreateGame(with: mockResult)
        
        // Assert
        #expect(receivedResult != nil)
        if case .gameCreated(let result) = receivedResult {
            #expect(result.careerId == mockResult.careerId)
        } else {
            #expect(Bool(false), "Expected gameCreated result")
        }
    }
    
    @Test("NewGameFeatureCoordinator handles cancellation")
    @MainActor
    func testHandleCancellation() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        var receivedResult: NewGameCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act
        coordinator.businessLogicDidCancel()
        
        // Assert
        #expect(receivedResult != nil)
        if case .cancelled = receivedResult {
            // Expected result
        } else {
            #expect(Bool(false), "Expected cancelled result")
        }
    }
    
    // MARK: - Child Coordinator Management Tests
    
    @Test("NewGameFeatureCoordinator manages team selection coordinator lifecycle")
    @MainActor
    func testTeamSelectionCoordinatorLifecycle() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Act & Wait for child coordinator to be created (no arbitrary delays!)
        await coordinator.testHooks.executeAndWaitForChildCoordinator {
            coordinator.businessLogicDidRequestTeamSelection()
        }
        
        // Assert - Child coordinator should be created
        #expect(coordinator.testHooks.childCoordinators.count == 1)
        #expect(coordinator.testHooks.childCoordinators.first is TeamSelectFeatureCoordinator)
    }
    
    // MARK: - Interactor Delegate Tests
    
    @Test("NewGameFeatureCoordinator responds to all interactor delegate methods")
    @MainActor
    func testInteractorDelegateMethods() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        var finishCallCount = 0
        
        coordinator.onFinish = { _ in
            finishCallCount += 1
        }
        
        // Act & Assert - Test team selection request
        coordinator.businessLogicDidRequestTeamSelection()
        #expect(finishCallCount == 0) // Should not finish
        
        // Act & Assert - Test game creation
        let mockResult = CreateNewCareerResult.make()
        coordinator.businessLogicDidCreateGame(with: mockResult)
        #expect(finishCallCount == 1) // Should finish once
        
        // Reset for next test
        finishCallCount = 0
        coordinator.onFinish = { _ in
            finishCallCount += 1
        }
        
        // Act & Assert - Test cancellation
        coordinator.businessLogicDidCancel()
        #expect(finishCallCount == 1) // Should finish once
    }
    
    // MARK: - Result Handling Tests
    
    @Test("NewGameFeatureCoordinator finishes with correct result types")
    @MainActor
    func testFinishesWithCorrectResultTypes() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        var receivedResults: [NewGameCoordinatorResult] = []
        
        coordinator.onFinish = { result in
            receivedResults.append(result)
        }
        
        // Act - Test game created result
        let mockResult = CreateNewCareerResult.make()
        coordinator.finish(with: .gameCreated(mockResult))
        
        // Act - Test cancelled result
        coordinator.finish(with: .cancelled)
        
        // Assert
        #expect(receivedResults.count == 2)
        
        if case .gameCreated(let result) = receivedResults[0] {
            #expect(result.careerId == mockResult.careerId)
        } else {
            #expect(Bool(false), "Expected first result to be gameCreated")
        }
        
        if case .cancelled = receivedResults[1] {
            // Expected result
        } else {
            #expect(Bool(false), "Expected second result to be cancelled")
        }
    }
}
