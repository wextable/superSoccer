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
    
    @Test func testInitFetchesTeamsFromStorage() async throws {
        // Arrange
        let mockStorage = MockSwiftDataStorage()
        let team1 = SDTeam.make()
        let team2 = SDTeam.make(
            info: SDTeamInfo.make(city: "Los Angeles", teamName: "Lakers")
        )
        mockStorage.mockTeams = [team1, team2]
        
        // Act
        let manager = SwiftDataManager(storage: mockStorage)
        
        // Assert
        var receivedTeams: [Team] = []
        let cancellable = manager.teamPublisher.sink { teams in
            receivedTeams = teams
        }
        
        #expect(receivedTeams.count == 2)
        #expect(receivedTeams[0].info.city == "Eugene")
        #expect(receivedTeams[0].info.teamName == "Duckies")
        #expect(receivedTeams[1].info.city == "Los Angeles")
        #expect(receivedTeams[1].info.teamName == "Lakers")
        
        cancellable.cancel()
    }
    
    @Test func testAddNewTeamWith() async throws {
        // Arrange
        let mockStorage = MockSwiftDataStorage()
        let manager = SwiftDataManager(storage: mockStorage)
        
        let teamInfo = TeamInfo.make()
        let player = Player.make()
        let team = Team.make(info: teamInfo, players: [player])
        
        // Act
        manager.addNewTeam(team)
        
        // Assert
        #expect(mockStorage.mockTeams.count == 1)
        #expect(mockStorage.mockTeams[0].info.city == "San Francisco")
        #expect(mockStorage.mockTeams[0].info.teamName == "49ers")
        #expect(mockStorage.mockTeams[0].players.count == 1)
        #expect(mockStorage.mockTeams[0].players[0].firstName == "Bo")
        #expect(mockStorage.mockTeams[0].players[0].lastName == "Nix")
        
        var receivedTeams: [Team] = []
        let cancellable = manager.teamPublisher.sink { teams in
            receivedTeams = teams
        }
        
        #expect(receivedTeams.count == 1)
        #expect(receivedTeams[0].info.city == "San Francisco")
        #expect(receivedTeams[0].info.teamName == "49ers")
        #expect(receivedTeams[0].players.count == 1)
        #expect(receivedTeams[0].players[0].firstName == "Bo")
        #expect(receivedTeams[0].players[0].lastName == "Nix")
        
        cancellable.cancel()
    }
    
//    @Test func testDeleteTeams() async throws {
//        // Arrange
//        let mockStorage = MockSwiftDataStorage()
//        let team1 = SDTeam.make(info: .make(city: "1"))
//        let team2 = SDTeam.make(info: .make(city: "2"))
//        let team3 = SDTeam.make(info: .make(city: "3"))
//        mockStorage.mockTeams = [team1, team2, team3]
//        
//        let manager = SwiftDataManager(storage: mockStorage)
//        
//        // Act
//        manager.deleteTeams(at: IndexSet([1])) // Delete "2"
//        
//        // Assert
//        #expect(mockStorage.mockTeams.count == 2)
//        #expect(mockStorage.mockTeams[0].info.city == "1")
//        #expect(mockStorage.mockTeams[1].info.city == "3")
//        
//        var receivedTeams: [Team] = []
//        let cancellable = manager.teamPublisher.sink { teams in
//            receivedTeams = teams
//        }
//        
//        #expect(receivedTeams.count == 2)
//        #expect(receivedTeams[0].info.city == "1")
//        #expect(receivedTeams[1].info.city == "3")
//        
//        cancellable.cancel()
//    }
    
    @Test func testTeamPublisherUpdatesWhenTeamsChange() async throws {
        // Arrange
        let mockStorage = MockSwiftDataStorage()
        let manager = SwiftDataManager(storage: mockStorage)
        
        var receivedTeamsSequence: [[Team]] = []
        let cancellable = manager.teamPublisher.sink { teams in
            receivedTeamsSequence.append(teams)
        }
        
        // Initial state should be empty
        #expect(receivedTeamsSequence.count == 1)
        #expect(receivedTeamsSequence[0].isEmpty)
        
        // Act 1: Add a team
        let team1 = Team.make(
            info: TeamInfo.make(city: "Chicago", teamName: "Bulls"),
            players: []
        )
        manager.addNewTeam(team1)
        
        // Assert 1
        #expect(receivedTeamsSequence.count == 2)
        #expect(receivedTeamsSequence[1].count == 1)
        #expect(receivedTeamsSequence[1][0].info.city == "Chicago")
        
        // Act 2: Add another team
        let team2 = Team.make(
            info: TeamInfo.make(city: "Los Angeles", teamName: "Lakers"),
            players: []
        )
        manager.addNewTeam(team2)
        
        // Assert 2
        #expect(receivedTeamsSequence.count == 3)
        #expect(receivedTeamsSequence[2].count == 2)
        #expect(receivedTeamsSequence[2][1].info.city == "Los Angeles")
        
//        // Act 3: Delete a team
//        manager.deleteTeams(at: IndexSet([0])) // Delete Chicago Bulls
//        
//        // Assert 3
//        #expect(receivedTeamsSequence.count == 4)
//        #expect(receivedTeamsSequence[3].count == 1)
//        #expect(receivedTeamsSequence[3][0].info.city == "Los Angeles")
        
        cancellable.cancel()
    }
}
