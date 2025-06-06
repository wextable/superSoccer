//
//  SwiftDataToClientTransformer.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct SwiftDataToClientTransformer {
    
    // MARK: - Core Entity Transforms
    
    func transform(_ sdCareer: SDCareer) -> Career {
        return Career(
            id: sdCareer.id,
            coachId: sdCareer.coach.id,
            userTeamId: sdCareer.userTeam.id,
            currentSeasonId: sdCareer.currentSeason.id,
            seasonIds: sdCareer.seasons.map { $0.id }
        )
    }
    
    func transform(_ sdCoach: SDCoach) -> Coach {
        return Coach(
            id: sdCoach.id,
            firstName: sdCoach.firstName,
            lastName: sdCoach.lastName
        )
    }
    
    func transform(_ sdTeam: SDTeam) -> Team {
        return Team(
            id: sdTeam.id,
            info: transform(sdTeam.info),
            coachId: sdTeam.coach.id,
            playerIds: sdTeam.players.map { $0.id },
            leagueId: sdTeam.league?.id
        )
    }
    
    func transform(_ sdTeamInfo: SDTeamInfo) -> TeamInfo {
        return TeamInfo(
            id: sdTeamInfo.id,
            city: sdTeamInfo.city,
            teamName: sdTeamInfo.teamName
        )
    }
    
    func transform(_ sdLeague: SDLeague) -> League {
        return League(
            id: sdLeague.id,
            name: sdLeague.name,
            teamIds: sdLeague.teams.map { $0.id }
        )
    }
    
    func transform(_ sdSeason: SDSeason) -> Season {
        return Season(
            id: sdSeason.id,
            seasonNumber: sdSeason.seasonNumber,
            year: sdSeason.year,
            isCompleted: sdSeason.isCompleted,
            leagueId: sdSeason.league.id,
            careerId: sdSeason.career?.id,
            matchIds: sdSeason.matches.map { $0.id }
        )
    }
    
    func transform(_ sdPlayer: SDPlayer) -> Player {
        return Player(
            id: sdPlayer.id,
            firstName: sdPlayer.firstName,
            lastName: sdPlayer.lastName,
            age: sdPlayer.age,
            position: sdPlayer.position,
            teamId: sdPlayer.team?.id
        )
    }
    
    func transform(_ sdMatch: SDMatch) -> Match {
        return Match(
            id: sdMatch.id,
            isCompleted: sdMatch.isCompleted,
            homeTeamId: sdMatch.homeTeam.id,
            awayTeamId: sdMatch.awayTeam.id,
            seasonId: sdMatch.season?.id
        )
    }
    
    func transform(_ sdContract: SDContract) -> Contract {
        return Contract(
            id: sdContract.id,
            startDate: sdContract.startDate,
            endDate: sdContract.endDate,
            salary: sdContract.salary,
            isActive: sdContract.isActive,
            playerId: sdContract.player.id,
            teamId: sdContract.team.id
        )
    }
    
    // MARK: - Stats Transforms
    
    func transform(_ sdPlayerStats: SDPlayerCareerStats) -> PlayerCareerStats {
        return PlayerCareerStats(
            id: sdPlayerStats.id,
            playerId: sdPlayerStats.player.id,
            totalGames: sdPlayerStats.totalGames,
            totalGoals: sdPlayerStats.totalGoals
        )
    }
    
    func transform(_ sdPlayerStats: SDPlayerSeasonStats) -> PlayerSeasonStats {
        return PlayerSeasonStats(
            id: sdPlayerStats.id,
            playerId: sdPlayerStats.player.id,
            seasonNumber: sdPlayerStats.seasonNumber,
            games: sdPlayerStats.games,
            goals: sdPlayerStats.goals
        )
    }
    
    func transform(_ sdPlayerStats: SDPlayerMatchStats) -> PlayerMatchStats {
        return PlayerMatchStats(
            id: sdPlayerStats.id,
            playerId: sdPlayerStats.player.id,
            matchId: sdPlayerStats.match.id,
            goals: sdPlayerStats.goals,
            minutesPlayed: sdPlayerStats.minutesPlayed
        )
    }
    
    func transform(_ sdTeamStats: SDTeamCareerStats) -> TeamCareerStats {
        return TeamCareerStats(
            id: sdTeamStats.id,
            teamId: sdTeamStats.team.id,
            totalGames: sdTeamStats.totalGames,
            totalWins: sdTeamStats.totalWins,
            totalDraws: sdTeamStats.totalDraws,
            totalLosses: sdTeamStats.totalLosses
        )
    }
    
    func transform(_ sdTeamStats: SDTeamSeasonStats) -> TeamSeasonStats {
        return TeamSeasonStats(
            id: sdTeamStats.id,
            teamId: sdTeamStats.team.id,
            seasonNumber: sdTeamStats.seasonNumber,
            games: sdTeamStats.games,
            wins: sdTeamStats.wins,
            draws: sdTeamStats.draws,
            losses: sdTeamStats.losses,
            points: sdTeamStats.goalsFor - sdTeamStats.goalsAgainst // Calculate points from goal difference for now
        )
    }
    
    func transform(_ sdTeamStats: SDTeamMatchStats) -> TeamMatchStats {
        return TeamMatchStats(
            id: sdTeamStats.id,
            teamId: sdTeamStats.team.id,
            matchId: sdTeamStats.match.id,
            goals: sdTeamStats.goals,
            possession: Int(sdTeamStats.possession), // Convert Double to Int
            shots: sdTeamStats.shots,
            shotsOnTarget: sdTeamStats.shotsOnTarget
        )
    }
}
