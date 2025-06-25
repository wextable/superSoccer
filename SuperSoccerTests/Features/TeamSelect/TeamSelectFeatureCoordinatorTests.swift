//
//  TeamSelectFeatureCoordinatorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Testing
import Combine
@testable import SuperSoccer

struct TeamSelectFeatureCoordinatorTests {
    
    // MARK: - Initialization Tests
    
    @Test("TeamSelectFeatureCoordinator initializes with correct dependencies")
    @MainActor
    func testInitializationWithCorrectDependencies() {
        // Arrange & Act
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        
        // Assert
        #expect(coordinator != nil)
    }
    
    // MARK: - Start Tests
    
    @Test("TeamSelectFeatureCoordinator start method presents team select sheet")
    @MainActor
    func testStartPresentsTeamSelectSheet() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        
        // Act
        coordinator.start()
        
        // Wait for async navigation
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert
        #expect(container.mockNavigationCoordinator.screenToPresent != nil)
    }
    
    // MARK: - Team Selection Tests
    
    @Test("TeamSelectFeatureCoordinator handles team selection")
    @MainActor
    func testHandleTeamSelection() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        var receivedResult: TeamSelectCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act
        let mockTeamInfo = TeamInfo.make()
        coordinator.interactorDidSelectTeam(mockTeamInfo)
        
        // Assert
        #expect(receivedResult != nil)
        if case .teamSelected(let teamInfo) = receivedResult {
            #expect(teamInfo.id == mockTeamInfo.id)
            #expect(teamInfo.teamName == mockTeamInfo.teamName)
        } else {
            #expect(Bool(false), "Expected teamSelected result")
        }
    }
    
    @Test("TeamSelectFeatureCoordinator handles cancellation")
    @MainActor
    func testHandleCancellation() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        var receivedResult: TeamSelectCoordinatorResult?
        
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
    
    // MARK: - Interactor Delegate Tests
    
    @Test("TeamSelectFeatureCoordinator responds to all interactor delegate methods")
    @MainActor
    func testInteractorDelegateMethods() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        var finishCallCount = 0
        
        coordinator.onFinish = { _ in
            finishCallCount += 1
        }
        
        // Act & Assert - Test team selection
        let mockTeamInfo = TeamInfo.make()
        coordinator.interactorDidSelectTeam(mockTeamInfo)
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
    
    @Test("TeamSelectFeatureCoordinator finishes with correct result types")
    @MainActor
    func testFinishesWithCorrectResultTypes() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        var receivedResults: [TeamSelectCoordinatorResult] = []
        
        coordinator.onFinish = { result in
            receivedResults.append(result)
        }
        
        // Act - Test team selected result
        let mockTeamInfo = TeamInfo.make()
        coordinator.finish(with: .teamSelected(mockTeamInfo))
        
        // Act - Test cancelled result
        coordinator.finish(with: .cancelled)
        
        // Assert
        #expect(receivedResults.count == 2)
        
        if case .teamSelected(let teamInfo) = receivedResults[0] {
            #expect(teamInfo.id == mockTeamInfo.id)
        } else {
            #expect(Bool(false), "Expected first result to be teamSelected")
        }
        
        if case .cancelled = receivedResults[1] {
            // Expected result
        } else {
            #expect(Bool(false), "Expected second result to be cancelled")
        }
    }
    
    // MARK: - Edge Cases
    
    @Test("TeamSelectFeatureCoordinator handles multiple team selections")
    @MainActor
    func testMultipleTeamSelections() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        var finishCallCount = 0
        
        coordinator.onFinish = { _ in
            finishCallCount += 1
        }
        
        // Act - Multiple team selections
        let mockTeamInfo1 = TeamInfo.make(teamName: "Team 1")
        let mockTeamInfo2 = TeamInfo.make(teamName: "Team 2")
        coordinator.interactorDidSelectTeam(mockTeamInfo1)
        coordinator.interactorDidSelectTeam(mockTeamInfo2)
        
        // Assert - Should handle gracefully
        #expect(finishCallCount >= 1) // At least one finish call should occur
        #expect(coordinator != nil)
    }
    
    @Test("TeamSelectFeatureCoordinator handles finish after already finished")
    @MainActor
    func testFinishAfterAlreadyFinished() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
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
    
    @Test("TeamSelectFeatureCoordinator handles mixed delegate calls")
    @MainActor
    func testMixedDelegateCalls() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        var receivedResults: [TeamSelectCoordinatorResult] = []
        
        coordinator.onFinish = { result in
            receivedResults.append(result)
        }
        
        // Act - Mixed calls
        let mockTeamInfo = TeamInfo.make()
        coordinator.interactorDidSelectTeam(mockTeamInfo)
        coordinator.interactorDidCancel()
        
        // Assert - Should handle gracefully
        #expect(receivedResults.count >= 1) // At least one result should be received
        #expect(coordinator != nil)
    }
    
    // MARK: - Navigation Integration Tests
    
    @Test("TeamSelectFeatureCoordinator integrates with navigation coordinator")
    @MainActor
    func testNavigationCoordinatorIntegration() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        
        // Act
        coordinator.start()
        
        // Wait for async navigation
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert
        #expect(container.mockNavigationCoordinator.screenToPresent != nil)
        
        // Verify the screen type is correct
        if case .teamSelect = container.mockNavigationCoordinator.screenToPresent {
            // Expected screen type
        } else {
            #expect(Bool(false), "Expected teamSelect screen to be presented")
        }
    }
    
    // MARK: - InteractorFactory Integration Tests
    
    @Test("TeamSelectFeatureCoordinator integrates with InteractorFactory correctly")
    @MainActor
    func testInteractorFactoryIntegration() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamSelectCoordinator()
        
        // Act
        coordinator.start()
        
        // Wait for async operations
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert - Verify interactor was created via factory
        #expect(coordinator.testHooks.interactor === container.mockInteractorFactory.mockTeamSelectInteractor)
        #expect(coordinator.testHooks.interactor != nil)
        
        // Verify the interactor is a mock instance
        let interactor = coordinator.testHooks.interactor
        #expect(interactor is MockTeamSelectInteractor)
    }
}
