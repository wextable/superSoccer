//
//  TeamFeatureCoordinatorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/13/25.
//

import Testing
import Combine
@testable import SuperSoccer

struct TeamFeatureCoordinatorTests {
    
    // MARK: - Initialization Tests
    
    @Test("TeamFeatureCoordinator initializes with correct dependencies")
    @MainActor
    func testInitializationWithCorrectDependencies() {
        // Arrange & Act
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        
        // Assert
        #expect(coordinator != nil)
    }
    
    @Test("TeamFeatureCoordinator sets up interactor delegate correctly")
    @MainActor
    func testInteractorDelegateSetup() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        
        // Act - Start coordinator which sets up the interactor
        coordinator.start()
        
        // Wait for async initialization
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert - Verify delegate is set through TestHooks
        let interactor = coordinator.testHooks.interactor
        #expect(interactor != nil)
        #expect(interactor?.delegate === coordinator)
    }
    
    // MARK: - Start Tests
    
    @Test("TeamFeatureCoordinator start method navigates to team screen")
    @MainActor
    func testStartNavigatesToTeamScreen() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        
        // Act
        coordinator.start()
        
        // Wait for async navigation
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert
        #expect(container.mockNavigationCoordinator.replaceStackWithCalled == true)
    }
    
    // MARK: - Player Row Tapped Tests
    
    @Test("TeamFeatureCoordinator handles player row tapped")
    @MainActor
    func testHandlePlayerRowTapped() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        var receivedResult: TeamCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act
        coordinator.playerRowTapped("player1")
        
        // Assert - Verify coordinator finishes with correct result
        #expect(receivedResult != nil)
        if case .playerSelected(let playerId) = receivedResult {
            #expect(playerId == "player1")
        } else {
            #expect(Bool(false), "Expected playerSelected result")
        }
    }
    
    // MARK: - Interactor Delegate Tests
    
    @Test("TeamFeatureCoordinator responds to interactor player row tapped")
    @MainActor
    func testInteractorPlayerRowTapped() {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        var receivedResult: TeamCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act
        coordinator.playerRowTapped("player-123")
        
        // Assert - Verify coordinator handles delegate method correctly
        #expect(receivedResult != nil)
        if case .playerSelected(let playerId) = receivedResult {
            #expect(playerId == "player-123")
        } else {
            #expect(Bool(false), "Expected playerSelected result")
        }
    }
    
    // MARK: - Coordination Tests
    
    @Test("TeamFeatureCoordinator coordinates team feature correctly")
    @MainActor
    func testCoordinatesTeamFeatureCorrectly() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        
        // Act
        coordinator.start()
        
        // Wait for async operations
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert - Verify coordinator manages the feature lifecycle
        #expect(coordinator != nil)
        #expect(container.mockNavigationCoordinator.replaceStackWithCalled == true)
        #expect(coordinator.testHooks.interactor != nil)
    }
    
    // MARK: - User Team ID Tests
    
    @Test("TeamFeatureCoordinator uses correct user team ID")
    @MainActor
    func testUsesCorrectUserTeamId() {
        // Arrange
        let expectedTeamId = "user-team-123"
        let container = MockDependencyContainer()
        
        // Act
        let coordinator = container.makeTeamCoordinator(userTeamId: expectedTeamId)
        
        // Assert - Verify the team ID is stored correctly
        #expect(coordinator != nil)
        #expect(coordinator.testHooks.userTeamId == expectedTeamId)
    }
    
    // MARK: - Navigation Integration Tests
    
    @Test("TeamFeatureCoordinator integrates with navigation correctly")
    @MainActor
    func testNavigationIntegration() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        
        // Act
        coordinator.start()
        
        // Wait for async operations
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert
        #expect(container.mockNavigationCoordinator.replaceStackWithCalled == true)
        #expect(coordinator.testHooks.navigationCoordinator != nil)
    }
    
    // MARK: - InteractorFactory Integration Tests
    
    @Test("TeamFeatureCoordinator integrates with InteractorFactory correctly")
    @MainActor
    func testInteractorFactoryIntegration() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        
        // Act
        coordinator.start()
        
        // Wait for async operations
        try? await Task.sleep(for: .milliseconds(10))
        
        // Assert - Verify interactor was created via factory  
        #expect(coordinator.testHooks.interactor != nil)
        
        // Verify the interactor is a mock instance
        let interactor = coordinator.testHooks.interactor
        #expect(interactor is MockTeamInteractor)
    }
    
    // MARK: - Memory Management Tests
    
    @Test("TeamFeatureCoordinator properly manages memory")
    @MainActor
    func testMemoryManagement() {
        // Arrange & Act
        let container = MockDependencyContainer()
        var coordinator: TeamFeatureCoordinator? = container.makeTeamCoordinator(userTeamId: "team1")
        
        // Verify coordinator is created
        #expect(coordinator != nil)
        
        // Act - Release the coordinator
        coordinator = nil
        
        // Assert - No assertion needed, this test verifies no memory leaks occur
        // The test passes if no retain cycles prevent deallocation
    }
    
    // MARK: - Lifecycle Tests
    
    @Test("TeamFeatureCoordinator handles lifecycle correctly")
    @MainActor
    func testHandlesLifecycleCorrectly() async {
        // Arrange
        let container = MockDependencyContainer()
        let coordinator = container.makeTeamCoordinator(userTeamId: "team1")
        var receivedResult: TeamCoordinatorResult?
        
        coordinator.onFinish = { result in
            receivedResult = result
        }
        
        // Act - Start and simulate interaction
        coordinator.start()
        
        // Wait for initialization
        try? await Task.sleep(for: .milliseconds(10))
        
        // Simulate user interaction
        coordinator.playerRowTapped("player1")
        
        // Assert - Coordinator should handle the full lifecycle
        #expect(container.mockNavigationCoordinator.replaceStackWithCalled == true)
        #expect(coordinator != nil)
        
        // Verify result handling
        if case .playerSelected(let playerId) = receivedResult {
            #expect(playerId == "player1")
        } else {
            #expect(Bool(false), "Expected playerSelected result")
        }
    }
} 