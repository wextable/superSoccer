//
//  ClientToSwiftDataTransformerTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Foundation
@testable import SuperSoccer
import Testing

struct ClientToSwiftDataTransformerTests {
    
    let transformer = ClientToSwiftDataTransformer()
    
    // MARK: - Career Creation Bundle Tests
    
    @Test func testCreateCareerEntitiesWithValidRequest() async throws {
        // Arrange
        let request = CreateNewCareerRequest.make(
            coachFirstName: "John",
            coachLastName: "Doe",
            selectedTeamInfoId: "team1",
            leagueName: "Premier League",
            seasonYear: 2024
        )
        
        let availableTeamInfos = [
            SDTeamInfo.make(id: "team1", city: "Manchester", teamName: "United"),
            SDTeamInfo.make(id: "team2", city: "Liverpool", teamName: "FC")
        ]
        
        // Act
        let bundle = transformer.createCareerEntities(from: request, availableTeamInfos: availableTeamInfos)
        
        // Assert
        #expect(bundle.career.id.isEmpty == false)
        #expect(bundle.coach.firstName == "John")
        #expect(bundle.coach.lastName == "Doe")
        #expect(bundle.league.name == "Premier League")
        #expect(bundle.season.year == 2024)
        #expect(bundle.season.seasonNumber == 1)
        #expect(bundle.season.isCompleted == false)
        #expect(bundle.teams.count == 2)
        #expect(bundle.players.count == 22) // 11 players per team
        #expect(bundle.teamInfos.count == 2)
        #expect(bundle.userTeamId == bundle.teams.first { $0.info.id == "team1" }?.id)
    }
    
    @Test func testCreateCareerEntitiesWithSingleTeam() async throws {
        // Arrange
        let request = CreateNewCareerRequest.make(
            coachFirstName: "Jane",
            coachLastName: "Smith",
            selectedTeamInfoId: "solo-team",
            leagueName: "Solo League",
            seasonYear: 2025
        )
        
        let availableTeamInfos = [
            SDTeamInfo.make(id: "solo-team", city: "Solo", teamName: "Rangers")
        ]
        
        // Act
        let bundle = transformer.createCareerEntities(from: request, availableTeamInfos: availableTeamInfos)
        
        // Assert
        #expect(bundle.teams.count == 1)
        #expect(bundle.players.count == 11)
        #expect(bundle.userTeamId == bundle.teams[0].id)
        #expect(bundle.teams[0].info.city == "Solo")
        #expect(bundle.teams[0].info.teamName == "Rangers")
    }
    
    @Test func testCreateCareerEntitiesRelationshipsAreSetCorrectly() async throws {
        // Arrange
        let request = CreateNewCareerRequest.make(
            selectedTeamInfoId: "team1",
            leagueName: "Test League"
        )
        
        let availableTeamInfos = [
            SDTeamInfo.make(id: "team1", city: "Test", teamName: "City"),
            SDTeamInfo.make(id: "team2", city: "Test", teamName: "United")
        ]
        
        // Act
        let bundle = transformer.createCareerEntities(from: request, availableTeamInfos: availableTeamInfos)
        
        // Assert - Check relationships are properly set
        #expect(bundle.career.coach.id == bundle.coach.id)
        #expect(bundle.career.currentSeason.id == bundle.season.id)
        #expect(bundle.career.seasons.count == 1)
        #expect(bundle.career.seasons[0].id == bundle.season.id)
        
        #expect(bundle.season.league.id == bundle.league.id)
        #expect(bundle.season.career?.id == bundle.career.id)
        
        #expect(bundle.league.teams.count == 2)
        for team in bundle.teams {
            #expect(team.league?.id == bundle.league.id)
            #expect(team.players.count == 11)
            // Verify player.team back-references are set
            for player in team.players {
                #expect(player.team?.id == team.id)
            }
        }
    }
    
    @Test func testCreateCareerEntitiesUserTeamHasCorrectCoach() async throws {
        // Arrange
        let request = CreateNewCareerRequest.make(
            coachFirstName: "User",
            coachLastName: "Coach",
            selectedTeamInfoId: "user-team"
        )
        
        let availableTeamInfos = [
            SDTeamInfo.make(id: "user-team", city: "User", teamName: "Team"),
            SDTeamInfo.make(id: "ai-team", city: "AI", teamName: "AI Team")
        ]
        
        // Act
        let bundle = transformer.createCareerEntities(from: request, availableTeamInfos: availableTeamInfos)
        
        // Assert
        let userTeam = try #require(bundle.teams.first { $0.info.id == "user-team" })
        let aiTeam = try #require(bundle.teams.first { $0.info.id == "ai-team" })
        
        #expect(userTeam.coach.firstName == "User")
        #expect(userTeam.coach.lastName == "Coach")
        #expect(aiTeam.coach.firstName == "Coach")
        #expect(aiTeam.coach.lastName == "AI Team")
    }
    
    @Test func testCreateCareerEntitiesGeneratesUniqueIds() async throws {
        // Arrange
        let request = CreateNewCareerRequest.make(selectedTeamInfoId: "team1")
        let availableTeamInfos = [
            SDTeamInfo.make(id: "team1", city: "Test", teamName: "One"),
            SDTeamInfo.make(id: "team2", city: "Test", teamName: "Two")
        ]
        
        // Act
        let bundle1 = transformer.createCareerEntities(from: request, availableTeamInfos: availableTeamInfos)
        let bundle2 = transformer.createCareerEntities(from: request, availableTeamInfos: availableTeamInfos)
        
        // Assert - All IDs should be unique between bundles
        #expect(bundle1.career.id != bundle2.career.id)
        #expect(bundle1.coach.id != bundle2.coach.id)
        #expect(bundle1.league.id != bundle2.league.id)
        #expect(bundle1.season.id != bundle2.season.id)
        
        for (team1, team2) in zip(bundle1.teams, bundle2.teams) {
            #expect(team1.id != team2.id)
        }
        
        for (player1, player2) in zip(bundle1.players, bundle2.players) {
            #expect(player1.id != player2.id)
        }
    }
    
    // MARK: - Individual Transform Tests
    
    @Test func testTransformCoach() async throws {
        // Arrange
        let coach = Coach.make(
            id: "coach123",
            firstName: "Test",
            lastName: "Coach"
        )
        
        // Act
        let sdCoach = transformer.transform(coach)
        
        // Assert
        #expect(sdCoach.id == "coach123")
        #expect(sdCoach.firstName == "Test")
        #expect(sdCoach.lastName == "Coach")
    }
    
    @Test func testTransformPlayer() async throws {
        // Arrange
        let player = Player.make(
            id: "player456",
            firstName: "Test",
            lastName: "Player",
            age: 25,
            position: "Forward"
        )
        
        // Act
        let sdPlayer = transformer.transform(player)
        
        // Assert
        #expect(sdPlayer.id == "player456")
        #expect(sdPlayer.firstName == "Test")
        #expect(sdPlayer.lastName == "Player")
        #expect(sdPlayer.age == 25)
        #expect(sdPlayer.position == "Forward")
    }
    
    // Note: Individual transform methods for Team, League, and Season are not implemented
    // and throw fatalError. These are intentionally not tested as they are placeholders.
    // The main functionality is tested through createCareerEntities which handles complex transformations.
}
