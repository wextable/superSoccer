//
//  ClientModels+TransformsTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/23/25.
//

import Testing
@testable import SuperSoccer

struct ClientModels_TransformsTests {

    @Test func testTeamInfoInitFromSDTeamInfo() async throws {
        // Arrange
        let sdTeamInfo = SDTeamInfo.make()
        
        // Act
        let teamInfo = TeamInfo(sdTeamInfo: sdTeamInfo)
        
        // Assert
        #expect(teamInfo.city == "Eugene")
        #expect(teamInfo.teamName == "Duckies")
    }
    
    @Test func testPlayerInitFromSDPlayer() async throws {
        // Arrange
        let sdPlayer = SDPlayer.make()
        
        // Act
        let player = Player(sdPlayer: sdPlayer)
        
        // Assert
        #expect(player.firstName == "Bo")
        #expect(player.lastName == "Nix")
    }
    
    @Test func testTeamInitFromSDTeam() async throws {
        // Arrange
        let sdTeamInfo = SDTeamInfo.make()
        
        let player1 = SDPlayer(firstName: "LeBron", lastName: "James")
        let player2 = SDPlayer.make()
        let players = [player1, player2]
        
        let sdTeam = SDTeam(info: sdTeamInfo, players: players)
        
        // Act
        let team = Team(sdTeam: sdTeam)
        
        // Assert
        #expect(team.info.city == "Eugene")
        #expect(team.info.teamName == "Duckies")
        #expect(team.players.count == 2)
        #expect(team.players[0].firstName == "LeBron")
        #expect(team.players[0].lastName == "James")
        #expect(team.players[1].firstName == "Bo")
        #expect(team.players[1].lastName == "Nix")
    }
    
    @Test func testTeamInitFromSDTeamWithEmptyPlayers() async throws {
        // Arrange
        let sdTeam = SDTeam.make(players: [])
        
        // Act
        let team = Team(sdTeam: sdTeam)
        
        // Assert
        #expect(team.info.city == "Eugene")
        #expect(team.info.teamName == "Duckies")
        #expect(team.players.isEmpty)
    }
}
