//
//  SwiftDataToClientTransformerTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Foundation
@testable import SuperSoccer
import Testing

struct SwiftDataToClientTransformerTests {
    
    let transformer = SwiftDataToClientTransformer()
    
    // MARK: - Core Entity Transform Tests
    
    @Test func testTransformCareer() async throws {
        // Arrange
        let sdCoach = SDCoach.make(id: "coach1", firstName: "John", lastName: "Doe")
        let sdTeamInfo = SDTeamInfo.make(id: "teaminfo1", city: "Test", teamName: "City")
        let sdUserTeam = SDTeam.make(id: "team1", info: sdTeamInfo, coach: sdCoach)
        let sdLeague = SDLeague.make(id: "league1", name: "Test League", teams: [sdUserTeam])
        let sdSeason = SDSeason.make(id: "season1", seasonNumber: 1, year: 2024, league: sdLeague)
        let sdCareer = SDCareer.make(
            id: "career1",
            coach: sdCoach,
            userTeam: sdUserTeam,
            currentSeason: sdSeason,
            seasons: [sdSeason]
        )
        
        // Act
        let career = transformer.transform(sdCareer)
        
        // Assert
        #expect(career.id == "career1")
        #expect(career.coachId == "coach1")
        #expect(career.userTeamId == "team1")
        #expect(career.currentSeasonId == "season1")
        #expect(career.seasonIds == ["season1"])
    }
    
    @Test func testTransformCoach() async throws {
        // Arrange
        let sdCoach = SDCoach.make(
            id: "coach123",
            firstName: "Jane",
            lastName: "Smith"
        )
        
        // Act
        let coach = transformer.transform(sdCoach)
        
        // Assert
        #expect(coach.id == "coach123")
        #expect(coach.firstName == "Jane")
        #expect(coach.lastName == "Smith")
    }
    
    @Test func testTransformTeam() async throws {
        // Arrange
        let sdTeamInfo = SDTeamInfo.make(id: "info1", city: "Manchester", teamName: "United")
        let sdCoach = SDCoach.make(id: "coach1", firstName: "Coach", lastName: "Name")
        let sdPlayer1 = SDPlayer.make(id: "player1", firstName: "Player", lastName: "One")
        let sdPlayer2 = SDPlayer.make(id: "player2", firstName: "Player", lastName: "Two")
        let sdLeague = SDLeague.make(id: "league1", name: "Premier League")
        let sdTeam = SDTeam.make(
            id: "team1",
            info: sdTeamInfo,
            coach: sdCoach,
            players: [sdPlayer1, sdPlayer2],
            league: sdLeague
        )
        
        // Act
        let team = transformer.transform(sdTeam)
        
        // Assert
        #expect(team.id == "team1")
        #expect(team.info.id == "info1")
        #expect(team.info.city == "Manchester")
        #expect(team.info.teamName == "United")
        #expect(team.coachId == "coach1")
        #expect(team.playerIds == ["player1", "player2"])
        #expect(team.leagueId == "league1")
    }
    
    @Test func testTransformTeamInfo() async throws {
        // Arrange
        let sdTeamInfo = SDTeamInfo.make(
            id: "info456",
            city: "Liverpool",
            teamName: "FC"
        )
        
        // Act
        let teamInfo = transformer.transform(sdTeamInfo)
        
        // Assert
        #expect(teamInfo.id == "info456")
        #expect(teamInfo.city == "Liverpool")
        #expect(teamInfo.teamName == "FC")
    }
    
    @Test func testTransformLeague() async throws {
        // Arrange
        let sdTeam1 = SDTeam.make(id: "team1")
        let sdTeam2 = SDTeam.make(id: "team2")
        let sdLeague = SDLeague.make(
            id: "league789",
            name: "Championship",
            teams: [sdTeam1, sdTeam2]
        )
        
        // Act
        let league = transformer.transform(sdLeague)
        
        // Assert
        #expect(league.id == "league789")
        #expect(league.name == "Championship")
        #expect(league.teamIds == ["team1", "team2"])
    }
    
    @Test func testTransformSeason() async throws {
        // Arrange
        let sdLeague = SDLeague.make(id: "league1", name: "Test League")
        let sdCareer = SDCareer.make(id: "career1")
        let sdMatch1 = SDMatch.make(id: "match1")
        let sdMatch2 = SDMatch.make(id: "match2")
        let sdSeason = SDSeason.make(
            id: "season123",
            seasonNumber: 2,
            year: 2025,
            isCompleted: true,
            league: sdLeague,
            matches: [sdMatch1, sdMatch2],
            career: sdCareer
        )
        
        // Act
        let season = transformer.transform(sdSeason)
        
        // Assert
        #expect(season.id == "season123")
        #expect(season.seasonNumber == 2)
        #expect(season.year == 2025)
        #expect(season.isCompleted == true)
        #expect(season.leagueId == "league1")
        #expect(season.careerId == "career1")
        #expect(season.matchIds == ["match1", "match2"])
    }
    
    @Test func testTransformPlayer() async throws {
        // Arrange
        let sdTeam = SDTeam.make(id: "team1")
        let sdPlayer = SDPlayer.make(
            id: "player456",
            firstName: "Cristiano",
            lastName: "Ronaldo",
            age: 38,
            position: "Forward",
            team: sdTeam
        )
        
        // Act
        let player = transformer.transform(sdPlayer)
        
        // Assert
        #expect(player.id == "player456")
        #expect(player.firstName == "Cristiano")
        #expect(player.lastName == "Ronaldo")
        #expect(player.age == 38)
        #expect(player.position == "Forward")
        #expect(player.teamId == "team1")
    }
    
    @Test func testTransformMatch() async throws {
        // Arrange
        let sdHomeTeam = SDTeam.make(id: "home-team")
        let sdAwayTeam = SDTeam.make(id: "away-team")
        let sdSeason = SDSeason.make(id: "season1")
        let sdMatch = SDMatch.make(
            id: "match789",
            isCompleted: true,
            homeTeam: sdHomeTeam,
            awayTeam: sdAwayTeam,
            season: sdSeason
        )
        
        // Act
        let match = transformer.transform(sdMatch)
        
        // Assert
        #expect(match.id == "match789")
        #expect(match.isCompleted == true)
        #expect(match.homeTeamId == "home-team")
        #expect(match.awayTeamId == "away-team")
        #expect(match.seasonId == "season1")
    }
    
    @Test func testTransformContract() async throws {
        // Arrange
        let startDate = Date()
        let endDate = Date().addingTimeInterval(365 * 24 * 60 * 60) // 1 year later
        let sdPlayer = SDPlayer.make(id: "player1")
        let sdTeam = SDTeam.make(id: "team1")
        let sdContract = SDContract.make(
            id: "contract123",
            startDate: startDate,
            endDate: endDate,
            salary: 50000,
            isActive: true,
            player: sdPlayer,
            team: sdTeam
        )
        
        // Act
        let contract = transformer.transform(sdContract)
        
        // Assert
        #expect(contract.id == "contract123")
        #expect(contract.startDate == startDate)
        #expect(contract.endDate == endDate)
        #expect(contract.salary == 50000)
        #expect(contract.isActive == true)
        #expect(contract.playerId == "player1")
        #expect(contract.teamId == "team1")
    }
    
    // MARK: - Stats Transform Tests
    
    @Test func testTransformPlayerCareerStats() async throws {
        // Arrange
        let sdPlayer = SDPlayer.make(id: "player1")
        let sdStats = SDPlayerCareerStats.make(
            id: "stats1",
            totalGames: 100,
            totalGoals: 25,
            player: sdPlayer
        )
        
        // Act
        let stats = transformer.transform(sdStats)
        
        // Assert
        #expect(stats.id == "stats1")
        #expect(stats.playerId == "player1")
        #expect(stats.totalGames == 100)
        #expect(stats.totalGoals == 25)
    }
    
    @Test func testTransformPlayerSeasonStats() async throws {
        // Arrange
        let sdPlayer = SDPlayer.make(id: "player2")
        let sdStats = SDPlayerSeasonStats.make(
            id: "season-stats1",
            seasonNumber: 3,
            games: 30,
            goals: 12,
            player: sdPlayer
        )
        
        // Act
        let stats = transformer.transform(sdStats)
        
        // Assert
        #expect(stats.id == "season-stats1")
        #expect(stats.playerId == "player2")
        #expect(stats.seasonNumber == 3)
        #expect(stats.games == 30)
        #expect(stats.goals == 12)
    }
    
    @Test func testTransformPlayerMatchStats() async throws {
        // Arrange
        let sdPlayer = SDPlayer.make(id: "player3")
        let sdMatch = SDMatch.make(id: "match1")
        let sdStats = SDPlayerMatchStats.make(
            id: "match-stats1",
            goals: 2,
            minutesPlayed: 90,
            player: sdPlayer,
            match: sdMatch
        )
        
        // Act
        let stats = transformer.transform(sdStats)
        
        // Assert
        #expect(stats.id == "match-stats1")
        #expect(stats.playerId == "player3")
        #expect(stats.matchId == "match1")
        #expect(stats.goals == 2)
        #expect(stats.minutesPlayed == 90)
    }
    
    @Test func testTransformTeamCareerStats() async throws {
        // Arrange
        let sdTeam = SDTeam.make(id: "team1")
        let sdStats = SDTeamCareerStats.make(
            id: "team-career-stats1",
            totalGames: 200,
            totalWins: 120,
            totalDraws: 40,
            totalLosses: 40,
            team: sdTeam
        )
        
        // Act
        let stats = transformer.transform(sdStats)
        
        // Assert
        #expect(stats.id == "team-career-stats1")
        #expect(stats.teamId == "team1")
        #expect(stats.totalGames == 200)
        #expect(stats.totalWins == 120)
        #expect(stats.totalDraws == 40)
        #expect(stats.totalLosses == 40)
    }
    
    @Test func testTransformTeamSeasonStats() async throws {
        // Arrange
        let sdTeam = SDTeam.make(id: "team2")
        let sdStats = SDTeamSeasonStats.make(
            id: "team-season-stats1",
            seasonNumber: 2,
            games: 38,
            wins: 25,
            draws: 8,
            losses: 5,
            goalsFor: 75,
            goalsAgainst: 30,
            team: sdTeam
        )
        
        // Act
        let stats = transformer.transform(sdStats)
        
        // Assert
        #expect(stats.id == "team-season-stats1")
        #expect(stats.teamId == "team2")
        #expect(stats.seasonNumber == 2)
        #expect(stats.games == 38)
        #expect(stats.wins == 25)
        #expect(stats.draws == 8)
        #expect(stats.losses == 5)
        #expect(stats.points == 45) // goalsFor - goalsAgainst = 75 - 30 = 45
    }
    
    @Test func testTransformTeamMatchStats() async throws {
        // Arrange
        let sdTeam = SDTeam.make(id: "team3")
        let sdMatch = SDMatch.make(id: "match2")
        let sdStats = SDTeamMatchStats.make(
            id: "team-match-stats1",
            goals: 3,
            possession: 65,
            shots: 15,
            shotsOnTarget: 8,
            team: sdTeam,
            match: sdMatch
        )
        
        // Act
        let stats = transformer.transform(sdStats)
        
        // Assert
        #expect(stats.id == "team-match-stats1")
        #expect(stats.teamId == "team3")
        #expect(stats.matchId == "match2")
        #expect(stats.goals == 3)
        #expect(stats.possession == 65) // Converted from Double to Int
        #expect(stats.shots == 15)
        #expect(stats.shotsOnTarget == 8)
    }
    
    // MARK: - Edge Cases
    
    @Test func testTransformTeamWithoutLeague() async throws {
        // Arrange
        let sdTeamInfo = SDTeamInfo.make(id: "info1", city: "Test", teamName: "Team")
        let sdCoach = SDCoach.make(id: "coach1")
        let sdTeam = SDTeam.make(
            id: "team1",
            info: sdTeamInfo,
            coach: sdCoach,
            players: [],
            league: nil
        )
        
        // Act
        let team = transformer.transform(sdTeam)
        
        // Assert
        #expect(team.id == "team1")
        #expect(team.leagueId == nil)
        #expect(team.playerIds.isEmpty)
    }
    
    @Test func testTransformPlayerWithoutTeam() async throws {
        // Arrange
        let sdPlayer = SDPlayer.make(
            id: "player1",
            firstName: "Free",
            lastName: "Agent",
            team: nil
        )
        
        // Act
        let player = transformer.transform(sdPlayer)
        
        // Assert
        #expect(player.id == "player1")
        #expect(player.firstName == "Free")
        #expect(player.lastName == "Agent")
        #expect(player.teamId == nil)
    }
    
    @Test func testTransformSeasonWithoutCareer() async throws {
        // Arrange
        let sdLeague = SDLeague.make(id: "league1")
        let sdSeason = SDSeason.make(
            id: "season1",
            league: sdLeague,
            matches: [],
            career: nil
        )
        
        // Act
        let season = transformer.transform(sdSeason)
        
        // Assert
        #expect(season.id == "season1")
        #expect(season.leagueId == "league1")
        #expect(season.careerId == nil)
        #expect(season.matchIds.isEmpty)
    }
}
