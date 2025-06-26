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
    
    // MARK: - Helper Methods
    
    private func createMocks() -> MockDataManager {
        return MockDataManager()
    }
    
    // MARK: - Initialization Tests
    
    @Test("TeamSelectInteractor initializes with correct dependencies")
    @MainActor
    func testInitializationWithDependencies() {
        // Arrange
        let mockDataManager = createMocks()
        
        // Act
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Assert
        #expect(interactor != nil)
        #expect(interactor.delegate === mockDelegate)
    }
    
    @Test("TeamSelectInteractor initializes with correct view model")
    @MainActor
    func testInitialViewModel() throws {
        // Arrange
        let mockDataManager = createMocks()
        let mockTeamInfos = [
            TeamInfo.make(city: "Portland", teamName: "Trail Blazers"),
            TeamInfo.make(city: "Golden State", teamName: "Warriors")
        ]
        mockDataManager.mockTeamInfos = mockTeamInfos
        
        // Act
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        
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
    
    // MARK: - Data Loading Tests
    
    @Test("TeamSelectInteractor loads team data correctly")
    @MainActor
    func testLoadTeamDataCorrectly() {
        // Arrange
        let mockDataManager = createMocks()
        let mockTeamInfos = [
            TeamInfo.make(id: "team1", city: "Manchester", teamName: "United"),
            TeamInfo.make(id: "team2", city: "Liverpool", teamName: "FC"),
            TeamInfo.make(id: "team3", city: "Arsenal", teamName: "FC")
        ]
        mockDataManager.mockTeamInfos = mockTeamInfos
        
        // Act
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        
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
        let mockDataManager = createMocks()
        mockDataManager.mockTeamInfos = []
        
        // Act
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        
        // Assert
        #expect(interactor.viewModel.title == "Select a team")
        #expect(interactor.viewModel.teamModels.isEmpty)
    }
    
    // MARK: - Function Interface Tests (Following NewGame Excellence)
    
    @Test("TeamSelectInteractor handles teamSelected function call")
    @MainActor
    func testTeamSelectedFunctionCall() {
        // Arrange
        let mockDataManager = createMocks()
        let mockTeamInfos = [
            TeamInfo.make(id: "team1", city: "Chelsea", teamName: "FC"),
            TeamInfo.make(id: "team2", city: "Tottenham", teamName: "Hotspur")
        ]
        mockDataManager.mockTeamInfos = mockTeamInfos
        
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.teamSelected(teamInfoId: "team1")
        
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
        let mockDataManager = createMocks()
        let teamInfo = TeamInfo.make(id: "test-team", city: "Test", teamName: "City")
        mockDataManager.mockTeamInfos = [teamInfo]
        
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.teamSelected(teamInfoId: "test-team")
        
        // Assert
        #expect(mockDelegate.didSelectTeam == true)
        #expect(mockDelegate.selectedTeam?.id == "test-team")
    }
    
    // MARK: - Delegate Communication Tests (Reliable Async Pattern)
    
    @Test("TeamSelectInteractor calls delegate on team selection with async confirmation")
    func testTeamSelectionDelegateAsync() async {
        // Arrange
        let mockDataManager = createMocks()
        let teamInfo = TeamInfo.make(id: "async-team", city: "Async", teamName: "City")
        mockDataManager.mockTeamInfos = [teamInfo]
        
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act & Wait for completion
        await withCheckedContinuation { continuation in
            mockDelegate.onDidSelectTeam = {
                continuation.resume()
            }
            interactor.teamSelected(teamInfoId: "async-team")
        }
        
        // Assert
        #expect(mockDelegate.didSelectTeam == true)
        #expect(mockDelegate.selectedTeam?.id == "async-team")
    }
    
    // MARK: - Edge Case Tests
    
    @Test("TeamSelectInteractor handles team selection for invalid ID gracefully")
    @MainActor
    func testTeamSelectionWithInvalidId() {
        // Arrange
        let mockDataManager = createMocks()
        let teamInfo = TeamInfo.make(id: "valid-team", city: "Valid", teamName: "Team")
        mockDataManager.mockTeamInfos = [teamInfo]
        
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.teamSelected(teamInfoId: "invalid-team")
        
        // Assert - Delegate should not be called for invalid ID
        #expect(mockDelegate.didSelectTeam == false)
        #expect(mockDelegate.selectedTeam == nil)
    }
    
    // MARK: - Memory Management Tests
    
    @Test("TeamSelectInteractor handles delegate lifecycle correctly")
    @MainActor
    func testDelegateLifecycle() {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        var mockDelegate: MockTeamSelectInteractorDelegate? = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act - Clear delegate reference
        mockDelegate = nil
        
        // Assert - Interactor should handle weak delegate gracefully
        #expect(interactor.delegate == nil)
    }
    
    // MARK: - Data Manager Integration Tests
    
    @Test("TeamSelectInteractor integrates with data manager correctly")
    @MainActor
    func testDataManagerIntegration() {
        // Arrange
        let mockDataManager = createMocks()
        let expectedTeamInfos = [
            TeamInfo.make(id: "integration1", city: "Integration", teamName: "Test1"),
            TeamInfo.make(id: "integration2", city: "Integration", teamName: "Test2")
        ]
        mockDataManager.mockTeamInfos = expectedTeamInfos
        
        // Act
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        
        // Assert - Verify data manager integration
        #expect(mockDataManager.fetchTeamInfosCalled == true)
        #expect(interactor.viewModel.teamModels.count == 2)
        
        let teamIds = interactor.viewModel.teamModels.map { $0.id }
        #expect(teamIds.contains("integration1"))
        #expect(teamIds.contains("integration2"))
    }
    
    // MARK: - Multiple Delegate Calls Tests
    
    @Test("TeamSelectInteractor handles multiple delegate calls correctly")
    @MainActor
    func testMultipleDelegateCalls() {
        // Arrange
        let mockDataManager = createMocks()
        let teamInfos = [
            TeamInfo.make(id: "team1", city: "First", teamName: "Team"),
            TeamInfo.make(id: "team2", city: "Second", teamName: "Team")
        ]
        mockDataManager.mockTeamInfos = teamInfos
        
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        let mockDelegate = MockTeamSelectInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.teamSelected(teamInfoId: "team1")
        interactor.teamSelected(teamInfoId: "team2")
        
        // Assert - Last call should be reflected
        #expect(mockDelegate.didSelectTeam == true)
        #expect(mockDelegate.selectedTeam?.id == "team2")
    }
    
    // MARK: - View Model Presentation Tests
    
    @Test("TeamSelectInteractor view model provides correct team models")
    @MainActor
    func testViewModelTeamModels() {
        // Arrange
        let mockDataManager = createMocks()
        let teamInfos = [
            TeamInfo.make(id: "vm1", city: "View", teamName: "Model1"),
            TeamInfo.make(id: "vm2", city: "View", teamName: "Model2")
        ]
        mockDataManager.mockTeamInfos = teamInfos
        
        // Act
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        
        // Assert
        let viewModel = interactor.viewModel
        #expect(viewModel.title == "Select a team")
        #expect(viewModel.teamModels.count == 2)
        
        let firstTeam = viewModel.teamModels.first(where: { $0.id == "vm1" })
        #expect(firstTeam?.text == "View Model1")
        
        let secondTeam = viewModel.teamModels.first(where: { $0.id == "vm2" })
        #expect(secondTeam?.text == "View Model2")
    }
    
    // MARK: - InteractorFactory Integration Tests
    
    @Test("TeamSelectInteractor factory integration works correctly")
    @MainActor
    func testInteractorFactoryIntegration() {
        // Arrange
        let container = MockDependencyContainer()
        
        // Act
        let interactor = container.interactorFactory.makeTeamSelectInteractor()
        
        // Assert - This should be a MockTeamSelectInteractor from the factory
        #expect(interactor is MockTeamSelectInteractor)
        #expect(interactor != nil)
    }
}
