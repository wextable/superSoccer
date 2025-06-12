//
//  ClientToSwiftDataTransformer.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct ClientToSwiftDataTransformer {
    
    // MARK: - Career Creation Bundle
    
    func createCareerEntities(
        from request: CreateNewCareerRequest, 
        availableTeamInfos: [SDTeamInfo]
    ) -> CareerCreationBundle {
        // Step 1: Create base entities (no relationships)
        let coach = createCoach(from: request)
        let (teams, teamInfos, players) = createTeamsAndPlayers(from: request, availableTeamInfos: availableTeamInfos)
        
        // Step 2: Create league with teams
        let league = createLeague(from: request, teams: teams)
        
        // Step 3: Set team.league back-references
        for team in teams {
            team.league = league
        }
        
        // Step 4: Create season with league
        let season = createSeason(from: request, league: league)
        
        // Step 5: Create career with all relationships
        let userTeam = teams.first { $0.info.id == request.selectedTeamInfoId }! // TODO: fix force unwrap
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
            teamInfos: teamInfos,
            userTeamId: userTeam.id
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
    
    private func createTeamsAndPlayers(
        from request: CreateNewCareerRequest, 
        availableTeamInfos: [SDTeamInfo]
    ) -> ([SDTeam], [SDTeamInfo], [SDPlayer]) {
        var teams: [SDTeam] = []
        var allPlayers: [SDPlayer] = []
        
        // Ensure we have at least some teams to work with
        guard !availableTeamInfos.isEmpty else {
            fatalError("No TeamInfo data provided. Ensure SwiftDataStorage.populateStaticData() has run.")
        }
        
        for teamInfo in availableTeamInfos {
            // Create players for this team
            var teamPlayers: [SDPlayer] = []
            for playerIndex in 1...11 {
                let player = SDPlayer(
                    id: UUID().uuidString,
                    firstName: "Player\(playerIndex)",
                    lastName: teamInfo.teamName,
                    age: Int.random(in: 18...35),
                    position: "Forward" // Simplified for now
                )
                teamPlayers.append(player)
                allPlayers.append(player)
            }
            
            // Create coach for this team (except user team which uses the main coach)
            let isUserTeam = (teamInfo.id == request.selectedTeamInfoId)
            let teamCoach: SDCoach
            if isUserTeam {
                teamCoach = createCoach(from: request)
            } else {
                teamCoach = SDCoach(
                    id: UUID().uuidString,
                    firstName: "Coach",
                    lastName: teamInfo.teamName
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
        
        return (teams, availableTeamInfos, allPlayers)
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
    
    private func createCareer(
        from request: CreateNewCareerRequest, 
        coach: SDCoach, 
        userTeam: SDTeam, currentSeason: SDSeason
    ) -> SDCareer {
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
    let userTeamId: String
}
