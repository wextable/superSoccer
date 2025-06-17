//
//  SwiftDataStorageTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Testing
import SwiftData
@testable import SuperSoccer

@MainActor
struct SwiftDataStorageTests {
    
//    private let container: ModelContainer
//    private let mockContext: ModelContext
//    
//    init() {
//        container = SwiftDataManagerFactory.mockModelContainer
//        mockContext = container.mainContext
//    }
//    
//    @Test func testFetchTeamsReturnsInitialTeams() async throws {
//        // Arrange
//        let storage = SwiftDataStorage(modelContext: mockContext)
//        
//        // Act
//        let teams = storage.fetchTeams()
//        
//        // Assert
//        #expect(teams.count == 2)
//        #expect(teams[0].info.city == "Alabama")
//        #expect(teams[0].info.teamName == "Crimson Tide Losers")
//        #expect(teams[1].info.city == "Auburn")
//        #expect(teams[1].info.teamName == "Tigers")
//    }
//    
//    @Test func testAddTeam() async throws {
//        // Arrange
//        let storage = SwiftDataStorage(modelContext: mockContext)
//        let newTeam = SDTeam.make(
//            info: SDTeamInfo.make(
//                city: "Eugene",
//                teamName: "Ducks"
//            )
//        )
//        
//        // Act
//        storage.addTeam(newTeam)
//        let teams = storage.fetchTeams()
//        
//        // Assert
//        #expect(teams.count == 3)
//        #expect(teams.contains { team in
//            team.info.city == "Eugene" && team.info.teamName == "Ducks"
//        })
//    }
//    
//    @Test func testDeleteTeam() async throws {
//        // Arrange
//        let storage = SwiftDataStorage(modelContext: mockContext)
//        let initialTeams = storage.fetchTeams()
//        let teamToDelete = initialTeams[0]
//        
//        // Act
//        storage.deleteTeam(teamToDelete)
//        let remainingTeams = storage.fetchTeams()
//        
//        // Assert
//        #expect(remainingTeams.count == 1)
//        #expect(!remainingTeams.contains { team in
//            team.info.city == teamToDelete.info.city &&
//            team.info.teamName == teamToDelete.info.teamName
//        })
//    }
//    
//    @Test func testDeleteAllTeams() async throws {
//        // Arrange
//        let storage = SwiftDataStorage(modelContext: mockContext)
//        let initialTeams = storage.fetchTeams()
//        
//        // Act
//        initialTeams.forEach { storage.deleteTeam($0) }
//        let remainingTeams = storage.fetchTeams()
//        
//        // Assert
//        #expect(remainingTeams.isEmpty)
//    }
//    
//    @Test func testAddTeamWithPlayers() async throws {
//        // Arrange
//        let storage = SwiftDataStorage(modelContext: mockContext)
//        let newTeam = SDTeam.make(
//            info: SDTeamInfo.make(
//                city: "Portland",
//                teamName: "Trail Blazers"
//            ),
//            players: [
//                SDPlayer.make(firstName: "Damian", lastName: "Lillard"),
//                SDPlayer.make(firstName: "CJ", lastName: "McCollum")
//            ]
//        )
//        
//        // Act
//        storage.addTeam(newTeam)
//        let teams = storage.fetchTeams()
//        let addedTeam = teams.first { $0.info.city == "Portland" }
//        
//        // Assert
//        #expect(addedTeam != nil)
//        #expect(addedTeam?.players.count == 2)
//        #expect(addedTeam?.players[0].firstName == "Damian")
//        #expect(addedTeam?.players[0].lastName == "Lillard")
//        #expect(addedTeam?.players[1].firstName == "CJ")
//        #expect(addedTeam?.players[1].lastName == "McCollum")
//    }
}
