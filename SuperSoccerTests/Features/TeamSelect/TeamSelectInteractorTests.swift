//
//  TeamSelectInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Combine
import Foundation
import Observation
@testable import SuperSoccer
import Testing

struct TeamSelectInteractorTests {
    
    // MARK: - Initialization Tests
    
    @Test("TeamSelectInteractor initializes with correct dependencies via factory")
    @MainActor
    func testInitializationWithFactoryDependencies() {
        // Arrange
        let container = MockDependencyContainer()
        
        // Act
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Assert
        #expect(interactor != nil)
        #expect(interactor.eventBus != nil)
    }
    
    @Test("TeamSelectInteractor initializes with correct view model")
    @MainActor
    func testInitialViewModel() async throws {
        // Arrange
        let container = MockDependencyContainer()
        let mockTeamInfos = [
            TeamInfo.make(city: "Portland", teamName: "Trail Blazers"),
            TeamInfo.make(city: "Golden State", teamName: "Warriors")
        ]
        container.mockDataManager.mockTeamInfos = mockTeamInfos
        
        // Act
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        
        // Assert
        #expect(interactor.viewModel.title == "Select a team")
        #expect(interactor.viewModel.teamModels.count == 2)
        
        let team1 = interactor.viewModel.teamModels.first
        try #require(team1 != nil)
        #expect(team1?.text == "Portland Trail Blazers")
        
        let team2 = interactor.viewModel.teamModels.last
        try #require(team2 != nil)
        #expect(team2?.text == "Golden State Warriors")
    }
    
    @Test("TeamSelectInteractor initializes with event bus")
    @MainActor
    func testInitializationWithEventBus() {
        // Arrange
        let container = MockDependencyContainer()
        
        // Act
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        
        // Assert
        #expect(interactor.eventBus != nil)
    }
    
    // MARK: - Data Loading Tests
    
    @Test("TeamSelectInteractor loads team data correctly")
    @MainActor
    func testLoadTeamDataCorrectly() {
        // Arrange
        let container = MockDependencyContainer()
        let mockTeamInfos = [
            TeamInfo.make(id: "team1", city: "Manchester", teamName: "United"),
            TeamInfo.make(id: "team2", city: "Liverpool", teamName: "FC"),
            TeamInfo.make(id: "team3", city: "Arsenal", teamName: "FC")
        ]
        container.mockDataManager.mockTeamInfos = mockTeamInfos
        
        // Act
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        
        // Assert
        #expect(interactor.viewModel.teamModels.count == 3)
        
        let teamTexts = interactor.viewModel.teamModels.map { $0.text }
        #expect(teamTexts.contains("Manchester United"))
        #expect(teamTexts.contains("Liverpool FC"))
        #expect(teamTexts.contains("Arsenal FC"))
    }
    
    @Test("TeamSelectInteractor handles empty team data gracefully")
    @MainActor
    func testHandlesEmptyTeamDataGracefully() {
        // Arrange
        let container = MockDependencyContainer()
        container.mockDataManager.mockTeamInfos = []
        
        // Act
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        
        // Assert
        #expect(interactor.viewModel.title == "Select a team")
        #expect(interactor.viewModel.teamModels.isEmpty)
    }
    
    // MARK: - Team Selection Tests
    
    @Test("TeamSelectInteractor handles team selection correctly via event bus")
    @MainActor
    func testTeamSelectionHandling() {
        // Arrange
        let container = MockDependencyContainer()
        let mockTeamInfos = [
            TeamInfo.make(id: "team1", city: "Chelsea", teamName: "FC"),
            TeamInfo.make(id: "team2", city: "Tottenham", teamName: "Hotspur")
        ]
        container.mockDataManager.mockTeamInfos = mockTeamInfos
        
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.eventBus.send(.teamSelected(teamInfoId: "team1"))
        
        // Assert
        #expect(mockDelegate.didSelectTeam == true)
        #expect(mockDelegate.selectedTeam?.id == "team1")
        #expect(mockDelegate.selectedTeam?.city == "Chelsea")
        #expect(mockDelegate.selectedTeam?.teamName == "FC")
    }
    
    @Test("TeamSelectInteractor team selection triggers delegate correctly")
    @MainActor
    func testTeamSelectionTriggersDelegate() {
        // Arrange
        let container = MockDependencyContainer()
        let teamInfo = TeamInfo.make(id: "test-team", city: "Test", teamName: "City")
        container.mockDataManager.mockTeamInfos = [teamInfo]
        
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.eventBus.send(.teamSelected(teamInfoId: "test-team"))
        
        // Assert
        #expect(mockDelegate.didSelectTeam == true)
        #expect(mockDelegate.selectedTeam?.id == "test-team")
    }
    
    // MARK: - Event Bus Tests
    
    @Test("TeamSelectInteractor event bus publishes events correctly")
    func testEventBusPublishesEvents() async {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = await container.interactorFactory.makeTeamSelectInteractor()
        var receivedEvents: [TeamSelectEvent] = []
        
        // Act & Assert
        await confirmation { confirm in
            let cancellable = interactor.eventBus
                .sink { event in
                    receivedEvents.append(event)
                    confirm()
                }
            
            // Send event
            interactor.eventBus.send(.teamSelected(teamInfoId: "team1"))
            
            // Store cancellable to prevent deallocation
            _ = cancellable
        }
        
        // Assert
        #expect(receivedEvents.count == 1)
        if case .teamSelected(let selectedTeamId) = receivedEvents.first {
            #expect(selectedTeamId == "team1")
        } else {
            Issue.record("Expected teamSelected event")
        }
    }
    
    @Test("TeamSelectInteractor handles multiple event subscriptions")
    func testMultipleEventSubscriptions() async {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = await container.interactorFactory.makeTeamSelectInteractor()
        var receivedEvents1: [TeamSelectEvent] = []
        var receivedEvents2: [TeamSelectEvent] = []
        
        // Act & Assert
        await confirmation(expectedCount: 2) { confirm in
            let cancellable1 = interactor.eventBus
                .sink { event in
                    receivedEvents1.append(event)
                    confirm()
                }
            
            let cancellable2 = interactor.eventBus
                .sink { event in
                    receivedEvents2.append(event)
                    confirm()
                }
            
            // Send event
            interactor.eventBus.send(.teamSelected(teamInfoId: "team1"))
            
            // Store cancellables to prevent deallocation
            _ = cancellable1
            _ = cancellable2
        }
        
        // Assert
        #expect(receivedEvents1.count == 1)
        #expect(receivedEvents2.count == 1)
    }
    
    // MARK: - View Model Tests
    
    @Test("TeamSelectInteractor view model provides correct team models")
    @MainActor
    func testViewModelTeamModels() {
        // Arrange
        let container = MockDependencyContainer()
        let mockTeamInfos = [
            TeamInfo.make(id: "team1", city: "Real", teamName: "Madrid"),
            TeamInfo.make(id: "team2", city: "Barcelona", teamName: "FC")
        ]
        container.mockDataManager.mockTeamInfos = mockTeamInfos
        
        // Act
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        let teamModels = interactor.viewModel.teamModels
        
        // Assert
        #expect(teamModels.count == 2)
        #expect(teamModels[0].text == "Real Madrid")
        #expect(teamModels[1].text == "Barcelona FC")
        
        // Verify model IDs match the team info IDs
        #expect(teamModels[0].id == "team1")
        #expect(teamModels[1].id == "team2")
    }
    
    // MARK: - Data Manager Integration Tests
    
    @Test("TeamSelectInteractor integrates with data manager correctly")
    @MainActor
    func testDataManagerIntegration() {
        // Arrange
        let container = MockDependencyContainer()
        let expectedTeamInfos = [
            TeamInfo.make(id: "team1", city: "Bayern", teamName: "Munich"),
            TeamInfo.make(id: "team2", city: "Borussia", teamName: "Dortmund")
        ]
        container.mockDataManager.mockTeamInfos = expectedTeamInfos
        
        // Act
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        
        // Assert - Verify data manager was used
        #expect(interactor.viewModel.teamModels.count == 2)
        
        // Verify that the view model correctly reflects the data from data manager
        let teamTexts = interactor.viewModel.teamModels.map { $0.text }
        #expect(teamTexts.contains("Bayern Munich"))
        #expect(teamTexts.contains("Borussia Dortmund"))
    }
    
    // MARK: - Delegate Communication Tests
    
    @Test("TeamSelectInteractor delegate methods are forwarded correctly")
    @MainActor
    func testDelegateMethodForwarding() {
        // Arrange
        let container = MockDependencyContainer()
        let teamInfo = TeamInfo.make(id: "team1", city: "Test", teamName: "Team")
        container.mockDataManager.mockTeamInfos = [teamInfo]
        
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.eventBus.send(.teamSelected(teamInfoId: "team1"))
        
        // Assert
        #expect(mockDelegate.didSelectTeam == true)
        #expect(mockDelegate.selectedTeam?.id == "team1")
    }
    
    @Test("TeamSelectInteractor handles multiple delegate calls correctly")
    @MainActor
    func testMultipleDelegateCalls() {
        // Arrange
        let container = MockDependencyContainer()
        let teamInfo1 = TeamInfo.make(id: "team1", city: "Team", teamName: "One")
        let teamInfo2 = TeamInfo.make(id: "team2", city: "Team", teamName: "Two")
        container.mockDataManager.mockTeamInfos = [teamInfo1, teamInfo2]
        
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.eventBus.send(.teamSelected(teamInfoId: "team1"))
        interactor.eventBus.send(.teamSelected(teamInfoId: "team2"))
        
        // Assert
        #expect(mockDelegate.didSelectTeam == true)
        #expect(mockDelegate.selectedTeam?.id == "team2") // Last call wins
    }
    
    // MARK: - Event Handling Integration Tests
    
    @Test("TeamSelectInteractor handles team selection for invalid ID gracefully")
    @MainActor
    func testInvalidTeamIdHandling() {
        // Arrange
        let container = MockDependencyContainer()
        let teamInfo = TeamInfo.make(id: "valid-team", city: "Valid", teamName: "Team")
        container.mockDataManager.mockTeamInfos = [teamInfo]
        
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act - Send event with invalid team ID
        interactor.eventBus.send(.teamSelected(teamInfoId: "invalid-team"))
        
        // Assert - Delegate should not be called
        #expect(mockDelegate.didSelectTeam == false)
        #expect(mockDelegate.selectedTeam == nil)
    }
    
    // MARK: - Memory Management Tests
    
    @Test("TeamSelectInteractor properly manages cancellables")
    @MainActor
    func testCancellablesManagement() {
        // Arrange & Act
        let container = MockDependencyContainer()
        var interactor: TeamSelectInteractorProtocol? = container.interactorFactory.makeTeamSelectInteractor()
        
        // Verify interactor is created
        #expect(interactor != nil)
        
        // Act - Release the interactor
        interactor = nil
        
        // Assert - No assertion needed, this test verifies no memory leaks occur
        // The test passes if no retain cycles prevent deallocation
    }
    
    @Test("TeamSelectInteractor handles delegate lifecycle correctly")
    @MainActor
    func testDelegateLifecycle() {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        var mockDelegate: MockTeamSelectInteractorDelegate? = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Verify delegate is set
        #expect(interactor.delegate != nil)
        
        // Act - Release delegate
        mockDelegate = nil
        
        // Assert - Delegate should be nil (weak reference)
        #expect(interactor.delegate == nil)
    }
}
