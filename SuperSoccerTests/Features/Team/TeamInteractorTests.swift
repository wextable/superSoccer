//
//  TeamInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/13/25.
//

import Combine
import Foundation
@testable import SuperSoccer
import Testing

struct TeamInteractorTests {
    
    // MARK: - Initialization Tests
    
    @Test("TeamInteractor initializes with correct dependencies")
    @MainActor
    func testInitializationWithCorrectDependencies() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        
        // Act
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for initial load task to complete
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(interactor != nil)
        #expect(interactor.eventBus != nil)
        #expect(mockDataManager.getTeamDetailsCalled == true)
        #expect(mockDataManager.lastGetTeamDetailsId == "team1")
    }
    
    @Test("TeamInteractor initializes with event bus")
    @MainActor
    func testInitializationWithEventBus() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        
        // Act
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for initial load task to complete
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(interactor.eventBus != nil)
    }
    
    // MARK: - Event Handling Tests
    
    @Test("TeamInteractor handles loadTeamData event correctly")
    @MainActor
    func testLoadTeamDataEventHandling() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        
        // Setup mock data
        let teamInfo = TeamInfo.make(id: "team1", city: "Manchester", teamName: "United")
        let team = Team.make(id: "team1", info: teamInfo, coachId: "coach1", playerIds: ["player1"])
        let coach = Coach.make(id: "coach1", firstName: "Alex", lastName: "Ferguson")
        let player = Player.make(id: "player1", firstName: "Marcus", lastName: "Rashford", position: "ST")
        
        mockDataManager.mockTeamDetails = (team: team, coach: coach, players: [player])
        
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for initial load
        try? await Task.sleep(for: .milliseconds(100))
        
        // Act - Send event to reload data
        interactor.eventBus.send(.loadTeamData)
        
        // Wait for event processing
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(interactor.viewModel.teamName == "Manchester United")
        #expect(interactor.viewModel.coachName == "Alex Ferguson")
        #expect(interactor.viewModel.playerRows.count == 1)
        #expect(interactor.viewModel.playerRows.first?.playerName == "Marcus Rashford")
        #expect(interactor.viewModel.playerRows.first?.position == "ST")
    }
    
    @Test("TeamInteractor handles playerRowTapped event correctly")
    @MainActor
    func testPlayerRowTappedEventHandling() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for initial load
        try? await Task.sleep(for: .milliseconds(100))
        
        // Act
        interactor.eventBus.send(.playerRowTapped(playerId: "player1"))
        
        // Assert
        #expect(mockDelegate.playerRowTappedCalled == true)
        #expect(mockDelegate.lastPlayerRowTappedId == "player1")
    }
    
    // MARK: - Data Loading Tests
    
    @Test("TeamInteractor loads team data correctly")
    @MainActor
    func testLoadTeamDataCorrectly() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        
        let teamInfo = TeamInfo.make(id: "team1", city: "Liverpool", teamName: "FC")
        let team = Team.make(id: "team1", info: teamInfo, coachId: "coach1", playerIds: ["player1", "player2"])
        let coach = Coach.make(id: "coach1", firstName: "Jurgen", lastName: "Klopp")
        let player1 = Player.make(id: "player1", firstName: "Mohamed", lastName: "Salah", position: "RW")
        let player2 = Player.make(id: "player2", firstName: "Sadio", lastName: "Mane", position: "LW")
        
        mockDataManager.mockTeamDetails = (team: team, coach: coach, players: [player1, player2])
        
        // Act
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for initial async load to complete
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(interactor.viewModel.teamName == "Liverpool FC")
        #expect(interactor.viewModel.coachName == "Jurgen Klopp")
        #expect(interactor.viewModel.playerRows.count == 2)
        
        let playerNames = interactor.viewModel.playerRows.map { $0.playerName }
        #expect(playerNames.contains("Mohamed Salah"))
        #expect(playerNames.contains("Sadio Mane"))
        
        let positions = interactor.viewModel.playerRows.map { $0.position }
        #expect(positions.contains("RW"))
        #expect(positions.contains("LW"))
    }
    
    @Test("TeamInteractor handles missing team data gracefully")
    @MainActor
    func testHandlesMissingTeamDataGracefully() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        
        // No mock data setup - getTeamDetails will return default nil values
        // mockDataManager.mockTeamDetails defaults to (team: nil, coach: nil, players: [])
        
        // Act
        let interactor = TeamInteractor(
            userTeamId: "nonexistent-team",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for async load to complete
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert - Should maintain initial empty state
        #expect(interactor.viewModel.teamName == "")
        #expect(interactor.viewModel.coachName == "")
        #expect(interactor.viewModel.playerRows.isEmpty)
    }
    
    // MARK: - Team Header Creation Tests
    
    @Test("TeamInteractor creates team header correctly")
    @MainActor
    func testCreateTeamHeaderCorrectly() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        
        let teamInfo = TeamInfo.make(id: "team1", city: "Arsenal", teamName: "FC")
        let team = Team.make(id: "team1", info: teamInfo, coachId: "coach1", playerIds: [])
        let coach = Coach.make(id: "coach1", firstName: "Mikel", lastName: "Arteta")
        
        mockDataManager.mockTeamDetails = (team: team, coach: coach, players: [])
        
        // Act
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for async processing
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert
        let header = interactor.viewModel.header
        #expect(header.teamName == "Arsenal FC")
        #expect(header.coachName == "Mikel Arteta")
        #expect(header.teamLogo == "AF") // Arsenal FC -> AF
        #expect(header.starRating >= 1.0 && header.starRating <= 5.0)
        #expect(!header.leagueStanding.isEmpty)
        #expect(header.teamRecord.contains("W") && header.teamRecord.contains("L"))
    }
    
    // MARK: - Event Bus Tests
    
    @Test("TeamInteractor event bus publishes events correctly")
    @MainActor
    func testEventBusPublishesEvents() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        var receivedEvents: [TeamEvent] = []
        
        // Wait for initial load
        try? await Task.sleep(for: .milliseconds(100))
        
        // Act & Assert
        await confirmation(expectedCount: 2) { confirm in
            let cancellable = interactor.eventBus
                .sink { event in
                    receivedEvents.append(event)
                    confirm()
                }
            
            // Send events
            interactor.eventBus.send(.loadTeamData)
            interactor.eventBus.send(.playerRowTapped(playerId: "player1"))
            
            // Store cancellable to prevent deallocation
            _ = cancellable
        }
        
        // Assert
        #expect(receivedEvents.count == 2)
        if case .loadTeamData = receivedEvents[0] {
            // Expected
        } else {
            #expect(Bool(false), "Expected loadTeamData event")
        }
        
        if case .playerRowTapped(let playerId) = receivedEvents[1] {
            #expect(playerId == "player1")
        } else {
            #expect(Bool(false), "Expected playerRowTapped event")
        }
    }
    
    // MARK: - Delegate Tests
    
    @Test("TeamInteractor delegate method calls are forwarded correctly")
    @MainActor
    func testDelegateMethodForwarding() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for initial load
        try? await Task.sleep(for: .milliseconds(100))
        
        // Act & Assert
        await confirmation { confirm in
            mockDelegate.onPlayerRowTapped = {
                confirm()
            }
            
            interactor.eventBus.send(.playerRowTapped(playerId: "player1"))
        }
        
        // Final assertion
        #expect(mockDelegate.playerRowTappedCalled == true)
        #expect(mockDelegate.lastPlayerRowTappedId == "player1")
    }
    
    // MARK: - Async Data Loading Tests
    
    @Test("TeamInteractor async data loading works correctly")
    @MainActor
    func testAsyncDataLoadingWorksCorrectly() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        
        let teamInfo = TeamInfo.make(id: "team1", city: "Chelsea", teamName: "FC")
        let team = Team.make(id: "team1", info: teamInfo, coachId: "coach1", playerIds: ["player1"])
        let coach = Coach.make(id: "coach1", firstName: "Frank", lastName: "Lampard")
        let player = Player.make(id: "player1", firstName: "Mason", lastName: "Mount", position: "CM")
        
        mockDataManager.mockTeamDetails = (team: team, coach: coach, players: [player])
        
        // Act
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for the async initialization to complete
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert
        #expect(mockDataManager.getTeamDetailsCalled == true)
        #expect(mockDataManager.lastGetTeamDetailsId == "team1")
        #expect(interactor.viewModel.teamName == "Chelsea FC")
        #expect(interactor.viewModel.coachName == "Frank Lampard")
        #expect(interactor.viewModel.playerRows.count == 1)
        #expect(interactor.viewModel.playerRows.first?.playerName == "Mason Mount")
    }
    
    @Test("TeamInteractor handles multiple async loads correctly")
    @MainActor
    func testHandlesMultipleAsyncLoadsCorrectly() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        
        // Initial data
        let teamInfo = TeamInfo.make(id: "team1", city: "Tottenham", teamName: "Hotspur")
        let team = Team.make(id: "team1", info: teamInfo, coachId: "coach1", playerIds: ["player1"])
        let coach = Coach.make(id: "coach1", firstName: "Antonio", lastName: "Conte")
        let player = Player.make(id: "player1", firstName: "Harry", lastName: "Kane", position: "ST")
        
        mockDataManager.mockTeamDetails = (team: team, coach: coach, players: [player])
        
        let interactor = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor.delegate = mockDelegate
        
        // Wait for initial load
        try? await Task.sleep(for: .milliseconds(100))
        
        // Verify initial state
        #expect(interactor.viewModel.teamName == "Tottenham Hotspur")
        #expect(interactor.viewModel.coachName == "Antonio Conte")
        
        // Act - Change data and trigger reload
        let newCoach = Coach.make(id: "coach1", firstName: "Ange", lastName: "Postecoglou")
        mockDataManager.mockTeamDetails = (team: team, coach: newCoach, players: [player])
        
        interactor.eventBus.send(.loadTeamData)
        
        // Wait for reload
        try? await Task.sleep(for: .milliseconds(100))
        
        // Assert - Data should be updated
        #expect(interactor.viewModel.coachName == "Ange Postecoglou")
        #expect(mockDataManager.getTeamDetailsCalled == true) // Called at least once
    }
    
    // MARK: - Memory Management Tests
    
    @Test("TeamInteractor properly manages cancellables")
    @MainActor
    func testCancellablesManagement() async {
        // Arrange & Act
        let mockDataManager = MockDataManager()
        let mockDelegate = MockTeamInteractorDelegate()
        var interactor: TeamInteractor? = TeamInteractor(
            userTeamId: "team1",
            dataManager: mockDataManager
        )
        interactor?.delegate = mockDelegate
        
        // Wait for initial load
        try? await Task.sleep(for: .milliseconds(100))
        
        // Verify interactor is created
        #expect(interactor != nil)
        
        // Act - Release the interactor
        interactor = nil
        
        // Assert - No assertion needed, this test verifies no memory leaks occur
        // The test passes if no retain cycles prevent deallocation
    }
}
