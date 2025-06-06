//
//  ClientToSwiftDataTransformer.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct ClientToSwiftDataTransformer {
    
    // MARK: - Career Creation Bundle
    
    func createCareerEntities(from request: CreateNewCareerRequest) -> CareerCreationBundle {
        // Step 1: Create base entities (no relationships)
        let coach = createCoach(from: request)
        let (teams, teamInfos, players) = createTeamsAndPlayers(from: request)
        
        // Step 2: Create league with teams
        let league = createLeague(from: request, teams: teams)
        
        // Step 3: Set team.league back-references
        for team in teams {
            team.league = league
        }
        
        // Step 4: Create season with league
        let season = createSeason(from: request, league: league)
        
        // Step 5: Create career with all relationships
        let userTeam = teams.first { $0.id == request.selectedTeamId }!
        let career = createCareer(from: request, coach: coach, userTeam: userTeam, currentSeason: season)
        
        // Step 6: Set season.career back-reference
        season.career = career
        
        return CareerCreationBundle(
            career: career,
            coach: coach,
            league: league,
            season: season,
            teams: teams,
            players: players,
            teamInfos: teamInfos
        )
    }
    
    // MARK: - Individual Entity Creation
    
    private func createCoach(from request: CreateNewCareerRequest) -> SDCoach {
        return SDCoach(
            id: UUID().uuidString,
            firstName: request.coachFirstName,
            lastName: request.coachLastName
        )
    }
    
    private func createTeamsAndPlayers(from request: CreateNewCareerRequest) -> ([SDTeam], [SDTeamInfo], [SDPlayer]) {
        var teams: [SDTeam] = []
        var teamInfos: [SDTeamInfo] = []
        var allPlayers: [SDPlayer] = []
        
        // For now, create a simple league structure
        // In the future, this could load from a data source or generate procedurally
        let teamNames = ["Arsenal", "Chelsea", "Liverpool", "Manchester United"]
        
        for (index, teamName) in teamNames.enumerated() {
            let teamInfo = SDTeamInfo(
                id: UUID().uuidString,
                city: "City\(index + 1)",
                teamName: teamName
            )
            teamInfos.append(teamInfo)
            
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
                teamPlayers.append(player)
                allPlayers.append(player)
            }
            
            // Create coach for this team (except user team which uses the main coach)
            let isUserTeam = (teamName == request.selectedTeamId) // Simplified matching
            let teamCoach: SDCoach
            if isUserTeam {
                teamCoach = createCoach(from: request)
            } else {
                teamCoach = SDCoach(
                    id: UUID().uuidString,
                    firstName: "Coach\(index + 1)",
                    lastName: "LastName"
                )
            }
            
            let team = SDTeam(
                id: UUID().uuidString,
                info: teamInfo,
                coach: teamCoach,
                players: teamPlayers
            )
            teams.append(team)
        }
        
        return (teams, teamInfos, allPlayers)
    }
    
    private func createLeague(from request: CreateNewCareerRequest, teams: [SDTeam]) -> SDLeague {
        return SDLeague(
            id: UUID().uuidString,
            name: request.leagueName,
            teams: teams
        )
    }
    
    private func createSeason(from request: CreateNewCareerRequest, league: SDLeague) -> SDSeason {
        return SDSeason(
            id: UUID().uuidString,
            seasonNumber: 1,
            year: request.seasonYear,
            isCompleted: false,
            league: league,
            matches: []
        )
    }
    
    private func createCareer(from request: CreateNewCareerRequest, coach: SDCoach, userTeam: SDTeam, currentSeason: SDSeason) -> SDCareer {
        return SDCareer(
            id: UUID().uuidString,
            coach: coach,
            userTeam: userTeam,
            currentSeason: currentSeason,
            seasons: [currentSeason]
        )
    }
    
    // MARK: - Individual Model Transforms
    
    func transform(_ coach: Coach) -> SDCoach {
        return SDCoach(
            id: coach.id,
            firstName: coach.firstName,
            lastName: coach.lastName
        )
    }
    
    func transform(_ team: Team) -> SDTeam {
        // Note: This would need more complex logic for full transformation
        // For now, simplified implementation
        fatalError("Individual team transform not yet implemented - use createCareerEntities for complex operations")
    }
    
    func transform(_ league: League) -> SDLeague {
        fatalError("Individual league transform not yet implemented - use createCareerEntities for complex operations")
    }
    
    func transform(_ season: Season) -> SDSeason {
        fatalError("Individual season transform not yet implemented - use createCareerEntities for complex operations")
    }
    
    func transform(_ player: Player) -> SDPlayer {
        return SDPlayer(
            id: player.id,
            firstName: player.firstName,
            lastName: player.lastName,
            age: player.age,
            position: player.position
        )
    }
}

// MARK: - Supporting Types

struct CareerCreationBundle {
    let career: SDCareer
    let coach: SDCoach
    let league: SDLeague
    let season: SDSeason
    let teams: [SDTeam]
    let players: [SDPlayer]
    let teamInfos: [SDTeamInfo]
}
