//
//  SwiftDataManagerTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Combine
import Foundation
@testable import SuperSoccer
import SwiftData
import Testing

struct SwiftDataManagerTests {
    
    // MARK: - Career Operations Tests
    
    @Test("Creating a new career should work")
    func testCreateNewCareer() async throws {
        // Arrange
        let storage = MockSwiftDataStorage()
        let manager = SwiftDataManager(storage: storage)
        
        let request = CreateNewCareerRequest(
            coachFirstName: "Hugh",
            coachLastName: "Freeze",
            selectedTeamInfoId: "1",
            leagueName: "English Premier League",
            seasonYear: 2025
        )
        
        // Act
        let result = try await manager.createNewCareer(request)
        
        // Assert
        let careers = manager.fetchCareers()
        let coaches = manager.fetchCoaches()
        let teams = manager.fetchTeams()
        
        #expect(careers.count == 1)
        #expect(coaches.count == 1)
        #expect(teams.count == 1)
        #expect(storage.mockCareers.count == 1)
        #expect(storage.mockCoaches.count == 1)
        #expect(storage.mockTeams.count == 1)
        #expect(careers[0].id == result.careerId)
        #expect(coaches[0].id == result.coachId)
        #expect(teams.contains { $0.id == result.userTeamId })
    }
    
    @Test("Career publishers should emit updates")
    func testCareerPublisherUpdates() async throws {
        // Arrange
        let storage = MockSwiftDataStorage()
        let manager = SwiftDataManager(storage: storage)
        var receivedCareers: [Career] = []
        
        let cancellable = manager.careerPublisher
            .sink { careers in
                receivedCareers = careers
            }
        
        // Act
        let request = CreateNewCareerRequest(
            coachFirstName: "Hugh",
            coachLastName: "Freeze",
            selectedTeamInfoId: "1",
            leagueName: "English Premier League",
            seasonYear: 2025
        )
        _ = try await manager.createNewCareer(request)
        
        // Assert
        #expect(!receivedCareers.isEmpty)
        #expect(receivedCareers.count == 1)
        #expect(storage.mockCareers.count == 1)
        
        cancellable.cancel()
    }
    
    @Test("League operations should work")
    func testLeagueOperations() async throws {
        // Arrange
        let storage = MockSwiftDataStorage()
        let manager = SwiftDataManager(storage: storage)
        var receivedLeagues: [League] = []
        
        let cancellable = manager.leaguePublisher
            .sink { leagues in
                receivedLeagues = leagues
            }
        
        // Create a career which will create a league
        let request = CreateNewCareerRequest(
            coachFirstName: "Hugh",
            coachLastName: "Freeze",
            selectedTeamInfoId: "1",
            leagueName: "English Premier League",
            seasonYear: 2025
        )
        _ = try await manager.createNewCareer(request)
        
        // Act
        let leagues = manager.fetchLeagues()
        
        // Assert
        #expect(!leagues.isEmpty)
        #expect(!receivedLeagues.isEmpty)
        #expect(storage.mockLeagues.count == 1)
        #expect(leagues.count == receivedLeagues.count)
        #expect(leagues[0].name == "English Premier League")
        
        cancellable.cancel()
    }
    
    @Test("Team operations should work")
    func testTeamOperations() async throws {
        // Arrange
        let storage = MockSwiftDataStorage()
        let manager = SwiftDataManager(storage: storage)
        var receivedTeams: [Team] = []
        
        let cancellable = manager.teamPublisher
            .sink { teams in
                receivedTeams = teams
            }
        
        // Create a career which will create teams
        let request = CreateNewCareerRequest(
            coachFirstName: "Hugh",
            coachLastName: "Freeze",
            selectedTeamInfoId: "1",
            leagueName: "English Premier League",
            seasonYear: 2025
        )
        _ = try await manager.createNewCareer(request)
        
        // Act
        let teams = manager.fetchTeams()
        let teamInfos = manager.fetchTeamInfos()
        
        // Assert
        #expect(!teams.isEmpty)
        #expect(!teamInfos.isEmpty)
        #expect(!receivedTeams.isEmpty)
        #expect(storage.mockTeams.count == 1)
        #expect(storage.mockTeamInfos.count == 1)
        #expect(teams.count == receivedTeams.count)
        
        cancellable.cancel()
    }
    
    @Test("Player operations should work")
    func testPlayerOperations() async throws {
        // Arrange
        let storage = MockSwiftDataStorage()
        let manager = SwiftDataManager(storage: storage)
        var receivedPlayers: [Player] = []
        
        let cancellable = manager.playerPublisher
            .sink { players in
                receivedPlayers = players
            }
        
        // Create a career which will create players
        let request = CreateNewCareerRequest(
            coachFirstName: "Hugh",
            coachLastName: "Freeze",
            selectedTeamInfoId: "1",
            leagueName: "English Premier League",
            seasonYear: 2025
        )
        _ = try await manager.createNewCareer(request)
        
        // Act
        let players = manager.fetchPlayers()
        
        // Assert
        #expect(!players.isEmpty)
        #expect(!receivedPlayers.isEmpty)
        #expect(storage.mockPlayers.count > 0)
        #expect(players.count == receivedPlayers.count)
        
        cancellable.cancel()
    }
    
    @Test("Coach operations should work")
    func testCoachOperations() async throws {
        // Arrange
        let storage = MockSwiftDataStorage()
        let manager = SwiftDataManager(storage: storage)
        var receivedCoaches: [Coach] = []
        
        let cancellable = manager.coachPublisher
            .sink { coaches in
                receivedCoaches = coaches
            }
        
        // Create a career which will create a coach
        let request = CreateNewCareerRequest(
            coachFirstName: "Hugh",
            coachLastName: "Freeze",
            selectedTeamInfoId: "1",
            leagueName: "English Premier League",
            seasonYear: 2025
        )
        _ = try await manager.createNewCareer(request)
        
        // Act
        let coaches = manager.fetchCoaches()
        
        // Assert
        #expect(!coaches.isEmpty)
        #expect(!receivedCoaches.isEmpty)
        #expect(storage.mockCoaches.count == 1)
        #expect(coaches[0].firstName == "Hugh")
        #expect(coaches[0].lastName == "Freeze")
        
        cancellable.cancel()
    }
}
