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
    
//    @Test func testInitFetchesTeamsFromStorage() async throws {
//        // Arrange
//        let mockStorage = MockSwiftDataStorage()
//        let team1 = SDTeam.make()
//        let team2 = SDTeam.make(
//            info: SDTeamInfo.make(city: "Los Angeles", teamName: "Lakers")
//        )
//        mockStorage.mockTeams = [team1, team2]
//        
//        // Act
//        let manager = SwiftDataManager(storage: mockStorage)
//        
//        // Assert
//        var receivedTeams: [Team] = []
//        let cancellable = manager.teamPublisher.sink { teams in
//            receivedTeams = teams
//        }
//        
//        #expect(receivedTeams.count == 2)
//        #expect(receivedTeams[0].info.city == "Eugene")
//        #expect(receivedTeams[0].info.teamName == "Duckies")
//        #expect(receivedTeams[1].info.city == "Los Angeles")
//        #expect(receivedTeams[1].info.teamName == "Lakers")
//        
//        cancellable.cancel()
//    }
//    
//    @Test func testAddNewTeamWith() async throws {
//        // Arrange
//        let mockStorage = MockSwiftDataStorage()
//        let manager = SwiftDataManager(storage: mockStorage)
//        
//        let teamInfo = TeamInfo.make()
//        let player = Player.make()
//        let team = Team.make(info: teamInfo, players: [player])
//        
//        // Act
//        manager.addNewTeam(team)
//        
//        // Assert
//        #expect(mockStorage.mockTeams.count == 1)
//        #expect(mockStorage.mockTeams[0].info.city == "San Francisco")
//        #expect(mockStorage.mockTeams[0].info.teamName == "49ers")
//        #expect(mockStorage.mockTeams[0].players.count == 1)
//        #expect(mockStorage.mockTeams[0].players[0].firstName == "Bo")
//        #expect(mockStorage.mockTeams[0].players[0].lastName == "Nix")
//        
//        var receivedTeams: [Team] = []
//        let cancellable = manager.teamPublisher.sink { teams in
//            receivedTeams = teams
//        }
//        
//        #expect(receivedTeams.count == 1)
//        #expect(receivedTeams[0].info.city == "San Francisco")
//        #expect(receivedTeams[0].info.teamName == "49ers")
//        #expect(receivedTeams[0].players.count == 1)
//        #expect(receivedTeams[0].players[0].firstName == "Bo")
//        #expect(receivedTeams[0].players[0].lastName == "Nix")
//        
//        cancellable.cancel()
//    }
//    
//    @Test func testTeamPublisherUpdatesWhenTeamsChange() async throws {
//        // Arrange
//        let mockStorage = MockSwiftDataStorage()
//        let manager = SwiftDataManager(storage: mockStorage)
//        
//        var receivedTeamsSequence: [[Team]] = []
//        let cancellable = manager.teamPublisher.sink { teams in
//            receivedTeamsSequence.append(teams)
//        }
//        
//        // Initial state should be empty
//        #expect(receivedTeamsSequence.count == 1)
//        #expect(receivedTeamsSequence[0].isEmpty)
//        
//        // Act 1: Add a team
//        
//        
//        // Assert 1
//        #expect(receivedTeamsSequence.count == 2)
//        #expect(receivedTeamsSequence[1].count == 1)
//        #expect(receivedTeamsSequence[1][0].info.city == "Chicago")
//        
//        // Act 2: Add another team
//        
//        
//        // Assert 2
//        #expect(receivedTeamsSequence.count == 3)
//        #expect(receivedTeamsSequence[2].count == 2)
//        #expect(receivedTeamsSequence[2][1].info.city == "Los Angeles")
//        
//        cancellable.cancel()
//    }
}
