//
//  SwiftDataStorageTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Testing
import SwiftData
@testable import SuperSoccer

struct SwiftDataStorageTests {
    
    // MARK: - Career Operations Tests
    
    @Test("Creating and fetching a career should work")
    func testCreateAndFetchCareer() async throws {
        // Arrange
        let modelContext = createInMemoryModelContext()
        let storage = SwiftDataStorage(modelContext: modelContext)
        let coach = SDCoach.make()
        let team = SDTeam.make()
        let season = SDSeason.make()
        let career = SDCareer.make(coach: coach, userTeam: team, currentSeason: season)
        
        // Act
        let createdCareer = try storage.createCareer(career)
        let fetchedCareers = storage.fetchCareers()
        let fetchedCareerById = storage.fetchCareer(by: career.id)
        
        // Assert
        #expect(fetchedCareers.count == 1)
        #expect(fetchedCareerById?.id == career.id)
        #expect(createdCareer.id == career.id)
    }
    
    // MARK: - League Operations Tests
    
    @Test("Creating and fetching a league should work")
    func testCreateAndFetchLeague() async throws {
        // Arrange
        let modelContext = createInMemoryModelContext()
        let storage = SwiftDataStorage(modelContext: modelContext)
        let league = SDLeague.make()
        
        // Act
        let createdLeague = try storage.createLeague(league)
        let fetchedLeagues = storage.fetchLeagues()
        
        // Assert
        #expect(fetchedLeagues.count == 1)
        #expect(createdLeague.id == league.id)
    }
    
    // MARK: - Season Operations Tests
    
    @Test("Creating and fetching a season should work")
    func testCreateAndFetchSeason() async throws {
        // Arrange
        let modelContext = createInMemoryModelContext()
        let storage = SwiftDataStorage(modelContext: modelContext)
        let season = SDSeason.make()
        
        // Act
        let createdSeason = try storage.createSeason(season)
        let fetchedSeasons = storage.fetchSeasons()
        
        // Assert
        #expect(fetchedSeasons.count == 1)
        #expect(createdSeason.id == season.id)
    }
    
    // MARK: - Team Operations Tests
    
    @Test("Creating and fetching a team should work")
    func testCreateAndFetchTeam() async throws {
        // Arrange
        let modelContext = createInMemoryModelContext()
        let storage = SwiftDataStorage(modelContext: modelContext)
        let team = SDTeam.make()
        
        // Act
        let createdTeam = try storage.createTeam(team)
        let fetchedTeams = storage.fetchTeams()
        
        // Assert
        #expect(fetchedTeams.count == 1)
        #expect(createdTeam.id == team.id)
    }
    
    // MARK: - Player Operations Tests
    
    @Test("Creating and fetching a player should work")
    func testCreateAndFetchPlayer() async throws {
        // Arrange
        let modelContext = createInMemoryModelContext()
        let storage = SwiftDataStorage(modelContext: modelContext)
        let player = SDPlayer.make()
        
        // Act
        let createdPlayer = try storage.createPlayer(player)
        let fetchedPlayers = storage.fetchPlayers()
        
        // Assert
        #expect(fetchedPlayers.count == 1)
        #expect(createdPlayer.id == player.id)
    }
    
    // MARK: - Coach Operations Tests
    
    @Test("Creating and fetching a coach should work")
    func testCreateAndFetchCoach() async throws {
        // Arrange
        let modelContext = createInMemoryModelContext()
        let storage = SwiftDataStorage(modelContext: modelContext)
        let coach = SDCoach.make()
        
        // Act
        let createdCoach = try storage.createCoach(coach)
        let fetchedCoaches = storage.fetchCoaches()
        
        // Assert
        #expect(fetchedCoaches.count == 1)
        #expect(createdCoach.id == coach.id)
    }
    
    // MARK: - Complex Operations Tests
    
    @Test("Creating a career bundle should work")
    func testCreateCareerBundle() async throws {
        // Arrange
        let modelContext = createInMemoryModelContext()
        let storage = SwiftDataStorage(modelContext: modelContext)
                
        let teamInfo = SDTeamInfo.make()
        let coach = SDCoach.make()
        let player = SDPlayer.make()
        let team = SDTeam.make(info: teamInfo, coach: coach, players: [player])
        let league = SDLeague.make(teams: [team])
        let season = SDSeason.make(league: league)
        let career = SDCareer.make(coach: coach, userTeam: team, currentSeason: season)
        
        let bundle = CareerCreationBundle(
            career: career,
            coach: coach,
            league: league,
            season: season,
            teams: [team],
            players: [player],
            teamInfos: [teamInfo],
            userTeamId: team.id
        )
        
        // Act
        let createdCareer = try storage.createCareerBundle(bundle)
        
        // Assert
        #expect(createdCareer.id == career.id)
        #expect(storage.fetchCoaches().count == 1)
        #expect(storage.fetchTeams().count == 1)
        #expect(storage.fetchPlayers().count == 1)
        #expect(storage.fetchLeagues().count == 1)
        #expect(storage.fetchSeasons().count == 1)
    }
    
    // MARK: - Helpers
    
    private func createInMemoryModelContext() -> ModelContext {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(
            for:
                SDCoach.self, SDCareer.self, SDLeague.self,
                SDSeason.self, SDTeam.self, SDPlayer.self,
                SDTeamInfo.self, SDContract.self,
                SDPlayerCareerStats.self, SDPlayerSeasonStats.self,
                SDPlayerMatchStats.self, SDTeamCareerStats.self,
                SDTeamSeasonStats.self, SDTeamMatchStats.self,
                SDMatch.self,
            configurations: config
        )
        return ModelContext(container)
    }
}
