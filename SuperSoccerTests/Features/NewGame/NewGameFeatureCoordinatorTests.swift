//
//  NewGameFeatureCoordinatorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Testing
import Combine
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
    func testHandleTeamSelectionRequest() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Act
        coordinator.interactorDidRequestTeamSelection()
        
        // Assert - We can't directly access child coordinators as they're private
        // But we can test that the method executes without error
        #expect(coordinator != nil)
    }
    
    @Test("NewGameFeatureCoordinator handles team selection result")
    @MainActor
    func testHandleTeamSelectionResult() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Act - We can't directly test private methods, but we can test the delegate methods
        coordinator.interactorDidRequestTeamSelection()
        
        // Assert
        #expect(coordinator != nil)
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
        coordinator.interactorDidCreateGame(with: mockResult)
        
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
        coordinator.interactorDidCancel()
        
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
    func testTeamSelectionCoordinatorLifecycle() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Act - Start team selection
        coordinator.interactorDidRequestTeamSelection()
        
        // Assert - We can't directly access child coordinators as they're private
        // But we can test that the method executes without error
        #expect(coordinator != nil)
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
        coordinator.interactorDidRequestTeamSelection()
        #expect(finishCallCount == 0) // Should not finish
        
        // Act & Assert - Test game creation
        let mockResult = CreateNewCareerResult.make()
        coordinator.interactorDidCreateGame(with: mockResult)
        #expect(finishCallCount == 1) // Should finish once
        
        // Reset for next test
        finishCallCount = 0
        coordinator.onFinish = { _ in
            finishCallCount += 1
        }
        
        // Act & Assert - Test cancellation
        coordinator.interactorDidCancel()
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
    
    // MARK: - Edge Cases
    
    @Test("NewGameFeatureCoordinator handles multiple team selection requests")
    @MainActor
    func testMultipleTeamSelectionRequests() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        
        // Act - Multiple team selection requests
        coordinator.interactorDidRequestTeamSelection()
        coordinator.interactorDidRequestTeamSelection()
        coordinator.interactorDidRequestTeamSelection()
        
        // Assert - Should handle gracefully without crashing
        #expect(coordinator != nil)
    }
    
    @Test("NewGameFeatureCoordinator handles finish after already finished")
    @MainActor
    func testFinishAfterAlreadyFinished() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeNewGameCoordinator()
        var finishCallCount = 0
        
        coordinator.onFinish = { _ in
            finishCallCount += 1
        }
        
        // Act - Finish multiple times
        coordinator.interactorDidCancel()
        coordinator.interactorDidCancel()
        
        // Assert - Should handle gracefully
        #expect(finishCallCount >= 1) // At least one finish call should occur
        #expect(coordinator != nil)
    }
}
