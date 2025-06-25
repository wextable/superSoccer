//
//  SwiftDataStorage.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Foundation
import SwiftData

protocol SwiftDataStorageProtocol {
    // Career Operations
    func createCareer(_ career: SDCareer) throws -> SDCareer
    func fetchCareers() -> [SDCareer]
    func fetchCareer(by id: String) -> SDCareer?
    
    // League Operations
    func createLeague(_ league: SDLeague) throws -> SDLeague
    func fetchLeagues() -> [SDLeague]
    
    // Season Operations
    func createSeason(_ season: SDSeason) throws -> SDSeason
    func fetchSeasons() -> [SDSeason]
    
    // Team Operations
    func createTeam(_ team: SDTeam) throws -> SDTeam
    func fetchTeams() -> [SDTeam]
    func fetchTeamInfos() -> [SDTeamInfo]
    
    // Player Operations
    func createPlayer(_ player: SDPlayer) throws -> SDPlayer
    func fetchPlayers() -> [SDPlayer]
    
    // Coach Operations
    func createCoach(_ coach: SDCoach) throws -> SDCoach
    func fetchCoaches() -> [SDCoach]
    
    // Complex Operations
    func createCareerBundle(_ bundle: CareerCreationBundle) throws -> SDCareer
    
    // Transaction Management
    func save() throws
    func rollback()
}

class SwiftDataStorage: SwiftDataStorageProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        populateStaticData()
    }
    
    private func populateStaticData() {
        // Add our initial teams if none exist
        if fetchTeamInfos().isEmpty {
            let auburnInfo = SDTeamInfo(city: "Auburn", teamName: "Tigers")
            let alabamaInfo = SDTeamInfo(city: "Alabama", teamName: "Crimson Tide Losers")
            
            _ = try? createTeamInfo(auburnInfo)
            _ = try? createTeamInfo(alabamaInfo)
        }
    }
    
    // MARK: - Career Operations
    
    func createCareer(_ career: SDCareer) throws -> SDCareer {
        modelContext.insert(career)
        try save()
        return career
    }
    
    func fetchCareers() -> [SDCareer] {
        let descriptor = FetchDescriptor<SDCareer>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchCareer(by id: String) -> SDCareer? {
        let predicate = #Predicate<SDCareer> { $0.id == id }
        let descriptor = FetchDescriptor<SDCareer>(predicate: predicate)
        return try? modelContext.fetch(descriptor).first
    }
    
    // MARK: - League Operations
    
    func createLeague(_ league: SDLeague) throws -> SDLeague {
        modelContext.insert(league)
        try save()
        return league
    }
    
    func fetchLeagues() -> [SDLeague] {
        let descriptor = FetchDescriptor<SDLeague>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Season Operations
    
    func createSeason(_ season: SDSeason) throws -> SDSeason {
        modelContext.insert(season)
        try save()
        return season
    }
    
    func fetchSeasons() -> [SDSeason] {
        let descriptor = FetchDescriptor<SDSeason>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Team Operations
    
    func createTeamInfo(_ teamInfo: SDTeamInfo) throws -> SDTeamInfo {
        modelContext.insert(teamInfo)
        try save()
        return teamInfo
    }
    
    func createTeam(_ team: SDTeam) throws -> SDTeam {
        modelContext.insert(team)
        try save()
        return team
    }
    
    func fetchTeams() -> [SDTeam] {
        let descriptor = FetchDescriptor<SDTeam>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func fetchTeamInfos() -> [SDTeamInfo] {
        let descriptor = FetchDescriptor<SDTeamInfo>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Player Operations
    
    func createPlayer(_ player: SDPlayer) throws -> SDPlayer {
        modelContext.insert(player)
        try save()
        return player
    }
    
    func fetchPlayers() -> [SDPlayer] {
        let descriptor = FetchDescriptor<SDPlayer>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Coach Operations
    
    func createCoach(_ coach: SDCoach) throws -> SDCoach {
        modelContext.insert(coach)
        try save()
        return coach
    }
    
    func fetchCoaches() -> [SDCoach] {
        let descriptor = FetchDescriptor<SDCoach>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    // MARK: - Complex Operations
    
    func createCareerBundle(_ bundle: CareerCreationBundle) throws -> SDCareer {
        // Insert all entities in the correct order to avoid relationship issues
        
        // 1. Insert base entities first (no relationships)
        modelContext.insert(bundle.coach)
        for teamInfo in bundle.teamInfos {
            modelContext.insert(teamInfo)
        }
        for player in bundle.players {
            modelContext.insert(player)
        }
        
        // 2. Insert teams (with coach, info, players relationships)
        for team in bundle.teams {
            modelContext.insert(team)
        }
        
        // 3. Insert league (with teams relationship)
        modelContext.insert(bundle.league)
        
        // 4. Insert season (with league relationship)
        modelContext.insert(bundle.season)
        
        // 5. Insert career (with all relationships)
        modelContext.insert(bundle.career)
        
        // 6. Save all changes
        try save()
        
        return bundle.career
    }
    
    // MARK: - Transaction Management
    
    func save() throws {
        try modelContext.save()
    }
    
    func rollback() {
        modelContext.rollback()
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
class MockSwiftDataStorage: SwiftDataStorageProtocol {
    var mockCareers: [SDCareer] = []
    var mockLeagues: [SDLeague] = []
    var mockSeasons: [SDSeason] = []
    var mockTeams: [SDTeam] = []
    var mockPlayers: [SDPlayer] = []
    var mockCoaches: [SDCoach] = []
    var mockTeamInfos: [SDTeamInfo] = []
    
    init(mockTeamInfos: [SDTeamInfo] = [.make()]) {
        self.mockTeamInfos = mockTeamInfos
    }
    
    // Career Operations
    func createCareer(_ career: SDCareer) throws -> SDCareer {
        mockCareers.append(career)
        return career
    }
    
    func fetchCareers() -> [SDCareer] { return mockCareers }
    func fetchCareer(by id: String) -> SDCareer? { return mockCareers.first { $0.id == id } }
    
    // League Operations
    func createLeague(_ league: SDLeague) throws -> SDLeague {
        mockLeagues.append(league)
        return league
    }
    
    func fetchLeagues() -> [SDLeague] { return mockLeagues }
    
    // Season Operations
    func createSeason(_ season: SDSeason) throws -> SDSeason {
        mockSeasons.append(season)
        return season
    }
    
    func fetchSeasons() -> [SDSeason] { return mockSeasons }
    
    // Team Operations
    func createTeam(_ team: SDTeam) throws -> SDTeam {
        mockTeams.append(team)
        return team
    }
    
    func fetchTeams() -> [SDTeam] { return mockTeams }
    func fetchTeamInfos() -> [SDTeamInfo] { return mockTeamInfos }
    
    // Player Operations
    func createPlayer(_ player: SDPlayer) throws -> SDPlayer {
        mockPlayers.append(player)
        return player
    }
    
    func fetchPlayers() -> [SDPlayer] { return mockPlayers }
    
    // Coach Operations
    func createCoach(_ coach: SDCoach) throws -> SDCoach {
        mockCoaches.append(coach)
        return coach
    }
    
    func fetchCoaches() -> [SDCoach] { return mockCoaches }
    
    // Complex Operations
    func createCareerBundle(_ bundle: CareerCreationBundle) throws -> SDCareer {
        // Only append entities that don't already exist (mimic database unique constraints)
        
        // Coach - check for existing ID
        if !mockCoaches.contains(where: { $0.id == bundle.coach.id }) {
            mockCoaches.append(bundle.coach)
        }
        
        // TeamInfos - only append new ones
        let newTeamInfos = bundle.teamInfos.filter { newInfo in
            !mockTeamInfos.contains { existing in existing.id == newInfo.id }
        }
        mockTeamInfos.append(contentsOf: newTeamInfos)
        
        // Players - only append new ones
        let newPlayers = bundle.players.filter { newPlayer in
            !mockPlayers.contains { existing in existing.id == newPlayer.id }
        }
        mockPlayers.append(contentsOf: newPlayers)
        
        // Teams - only append new ones
        let newTeams = bundle.teams.filter { newTeam in
            !mockTeams.contains { existing in existing.id == newTeam.id }
        }
        mockTeams.append(contentsOf: newTeams)
        
        // League - check for existing ID
        if !mockLeagues.contains(where: { $0.id == bundle.league.id }) {
            mockLeagues.append(bundle.league)
        }
        
        // Season - check for existing ID
        if !mockSeasons.contains(where: { $0.id == bundle.season.id }) {
            mockSeasons.append(bundle.season)
        }
        
        // Career - check for existing ID
        if !mockCareers.contains(where: { $0.id == bundle.career.id }) {
            mockCareers.append(bundle.career)
        }
        
        return bundle.career
    }
    
    // Transaction Management
    func save() throws { /* Mock - no-op */ }
    func rollback() { /* Mock - no-op */ }
}
#endif
