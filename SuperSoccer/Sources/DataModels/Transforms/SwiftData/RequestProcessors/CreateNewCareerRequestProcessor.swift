//
//  CreateNewCareerRequestProcessor.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

struct CreateNewCareerRequestProcessor: ComplexRequestProcessor {
    typealias Input = CreateNewCareerRequest
    typealias Output = CreateNewCareerResult
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func process(_ request: CreateNewCareerRequest) async throws -> CreateNewCareerResult {
        // Implementation follows the creation sequence to avoid circular dependencies:
        // 1. Create base entities: SDCoach, SDTeamInfo, SDPlayer (no relationships)
        // 2. Create SDTeam (with coach, info, players)
        // 3. Create SDLeague (with teams)
        // 4. Set team.league back-references
        // 5. Create SDSeason (with league)
        // 6. Create SDCareer (with coach, userTeam, currentSeason)
        // 7. Set season.career back-reference
        // 8. Create stats entities and set relationships
        
        // Step 1: Create base entities
        let coach = try await createCoach(request: request)
        let (teams, players) = try await createTeamsAndPlayers(request: request)
        
        // Step 2: Teams are already created with relationships
        
        // Step 3: Create League
        let league = try await createLeague(request: request, teams: teams)
        
        // Step 4: Set team.league back-references
        try await setTeamLeagueReferences(teams: teams, league: league)
        
        // Step 5: Create Current Season
        let currentSeason = try await createSeason(request: request, league: league)
        
        // Step 6: Create Career
        let userTeam = teams.first { $0.id == request.selectedTeamId }!
        let career = try await createCareer(request: request, coach: coach, userTeam: userTeam, currentSeason: currentSeason)
        
        // Step 7: Set season.career back-reference
        try await setSeasonCareerReference(season: currentSeason, career: career)
        
        // Step 8: Create stats entities (placeholder for now)
        try await createInitialStats(teams: teams, players: players)
        
        // Save all changes
        try modelContext.save()
        
        // Return result with IDs
        return CreateNewCareerResult(
            careerId: career.id,
            coachId: coach.id,
            userTeamId: userTeam.id,
            leagueId: league.id,
            currentSeasonId: currentSeason.id,
            allTeamIds: teams.map { $0.id },
            allPlayerIds: players.map { $0.id }
        )
    }
    
    // MARK: - Private Helper Methods
    
    private func createCoach(request: CreateNewCareerRequest) async throws -> SDCoach {
        let coach = SDCoach(
            id: UUID().uuidString,
            firstName: request.coachFirstName,
            lastName: request.coachLastName
        )
        modelContext.insert(coach)
        return coach
    }
    
    private func createTeamsAndPlayers(request: CreateNewCareerRequest) async throws -> ([SDTeam], [SDPlayer]) {
        // This would normally load from a data source or generate procedurally
        // For now, create a simple league structure
        var teams: [SDTeam] = []
        var allPlayers: [SDPlayer] = []
        
        let teamNames = ["Arsenal", "Chelsea", "Liverpool", "Manchester United"]
        
        for (index, teamName) in teamNames.enumerated() {
            let teamInfo = SDTeamInfo(
                id: UUID().uuidString,
                city: "City\(index + 1)",
                teamName: teamName
            )
            modelContext.insert(teamInfo)
            
            // Create players for this team
            var teamPlayers: [SDPlayer] = []
            for playerIndex in 1...11 {
                let player = SDPlayer(
                    id: UUID().uuidString,
                    firstName: "Player\(playerIndex)",
                    lastName: "Team\(index + 1)",
                    age: Int.random(in: 18...35),
                    position: "Forward" // Simplified for now
                )
                modelContext.insert(player)
                teamPlayers.append(player)
                allPlayers.append(player)
            }
            
            // Create coach for this team (except user team)
            let isUserTeam = (index == 0) // First team is user team for simplicity
            let coachFirstName = isUserTeam ? request.coachFirstName : "Coach\(index + 1)"
            let coachLastName = isUserTeam ? request.coachLastName : "LastName"
            let teamCoach = SDCoach(
                id: UUID().uuidString,
                firstName: coachFirstName,
                lastName: coachLastName
            )
            modelContext.insert(teamCoach)
            
            let team = SDTeam(
                id: UUID().uuidString,
                info: teamInfo,
                coach: teamCoach,
                players: teamPlayers
            )
            modelContext.insert(team)
            teams.append(team)
        }
        
        return (teams, allPlayers)
    }
    
    private func createLeague(request: CreateNewCareerRequest, teams: [SDTeam]) async throws -> SDLeague {
        let league = SDLeague(
            id: UUID().uuidString,
            name: request.leagueName,
            teams: teams
        )
        modelContext.insert(league)
        return league
    }
    
    private func setTeamLeagueReferences(teams: [SDTeam], league: SDLeague) async throws {
        for team in teams {
            team.league = league
        }
    }
    
    private func createSeason(request: CreateNewCareerRequest, league: SDLeague) async throws -> SDSeason {
        let season = SDSeason(
            id: UUID().uuidString,
            seasonNumber: 1,
            year: request.seasonYear,
            isCompleted: false,
            league: league,
            matches: []
        )
        modelContext.insert(season)
        return season
    }
    
    private func createCareer(request: CreateNewCareerRequest, coach: SDCoach, userTeam: SDTeam, currentSeason: SDSeason) async throws -> SDCareer {
        let career = SDCareer(
            id: UUID().uuidString,
            coach: coach,
            userTeam: userTeam,
            currentSeason: currentSeason,
            seasons: [currentSeason]
        )
        modelContext.insert(career)
        return career
    }
    
    private func setSeasonCareerReference(season: SDSeason, career: SDCareer) async throws {
        season.career = career
    }
    
    private func createInitialStats(teams: [SDTeam], players: [SDPlayer]) async throws {
        // Create initial empty stats for all teams and players
        for team in teams {
            let teamCareerStats = SDTeamCareerStats(
                id: UUID().uuidString,
                totalGames: 0,
                totalWins: 0,
                totalDraws: 0,
                totalLosses: 0,
                team: team
            )
            modelContext.insert(teamCareerStats)
        }
        
        for player in players {
            let playerCareerStats = SDPlayerCareerStats(
                id: UUID().uuidString,
                totalGames: 0,
                totalGoals: 0,
                player: player
            )
            modelContext.insert(playerCareerStats)
        }
    }
}
