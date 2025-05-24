//
//  SwiftDataModels+TransformsTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/23/25.
//

import Testing
@testable import SuperSoccer

struct SwiftDataModels_TransformsTests {

    @Test func testSDTeamInfoInitFrom() async throws {
        // Arrange
        let teamInfo = TeamInfo.make()
        
        // Act
        let sdTeamInfo = SDTeamInfo(clientModel: teamInfo)
        
        // Assert
        #expect(sdTeamInfo.city == "San Francisco")
        #expect(sdTeamInfo.teamName == "49ers")
    }
    
    @Test func testSDPlayerInitFrom() async throws {
        // Arrange
        let player = Player.make()
        
        // Act
        let sdPlayer = SDPlayer(clientModel: player)
        
        // Assert
        #expect(sdPlayer.firstName == "Bo")
        #expect(sdPlayer.lastName == "Nix")
    }
    
    @Test func testSDTeamInitFromTeam() async throws {
        // Arrange
        let teamInfo = TeamInfo.make()
        let player1 = Player.make()
        let player2 = Player.make(
            id: "`2",
            firstName: "Anthony",
            lastName: "Davis"
        )
        let team = Team.make(
            info: teamInfo,
            players: [player1, player2]
        )
        
        // Act
        let sdTeam = SDTeam(clientModel: team)
        
        // Assert
        #expect(sdTeam.info.city == "San Francisco")
        #expect(sdTeam.info.teamName == "49ers")
        #expect(sdTeam.players.count == 2)
        #expect(sdTeam.players[0].firstName == "Bo")
        #expect(sdTeam.players[0].lastName == "Nix")
        #expect(sdTeam.players[1].firstName == "Anthony")
        #expect(sdTeam.players[1].lastName == "Davis")
    }
    
    @Test func testSDTeamInitFromTeamWithEmptyPlayers() async throws {
        // Arrange
        let team = Team.make(players: [])
        
        // Act
        let sdTeam = SDTeam(clientModel: team)
        
        // Assert
        #expect(sdTeam.info.city == "San Francisco")
        #expect(sdTeam.info.teamName == "49ers")
        #expect(sdTeam.players.isEmpty)
    }
}
