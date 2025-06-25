//
//  TeamStats.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

// Career stats for a team
struct TeamCareerStats: Identifiable, Hashable, Equatable {
    let id: String
    let teamId: String
    let totalGames: Int
    let totalWins: Int
    let totalDraws: Int
    let totalLosses: Int
}

// Season stats for a team
struct TeamSeasonStats: Identifiable, Hashable, Equatable {
    let id: String
    let teamId: String
    let seasonNumber: Int
    let games: Int
    let wins: Int
    let draws: Int
    let losses: Int
    let points: Int
}

// Match stats for a team
struct TeamMatchStats: Identifiable, Hashable, Equatable {
    let id: String
    let teamId: String
    let matchId: String
    let goals: Int
    let possession: Int
    let shots: Int
    let shotsOnTarget: Int
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamCareerStats {
    static func make(
        id: String = "1",
        teamId: String = "1",
        totalGames: Int = 100,
        totalWins: Int = 60,
        totalDraws: Int = 20,
        totalLosses: Int = 20
    ) -> TeamCareerStats {
        return TeamCareerStats(
            id: id,
            teamId: teamId,
            totalGames: totalGames,
            totalWins: totalWins,
            totalDraws: totalDraws,
            totalLosses: totalLosses
        )
    }
}

extension TeamSeasonStats {
    static func make(
        id: String = "1",
        teamId: String = "1",
        seasonNumber: Int = 1,
        games: Int = 38,
        wins: Int = 25,
        draws: Int = 8,
        losses: Int = 5,
        points: Int = 83
    ) -> TeamSeasonStats {
        return TeamSeasonStats(
            id: id,
            teamId: teamId,
            seasonNumber: seasonNumber,
            games: games,
            wins: wins,
            draws: draws,
            losses: losses,
            points: points
        )
    }
}

extension TeamMatchStats {
    static func make(
        id: String = "1",
        teamId: String = "1",
        matchId: String = "1",
        goals: Int = 2,
        possession: Int = 65,
        shots: Int = 15,
        shotsOnTarget: Int = 8
    ) -> TeamMatchStats {
        return TeamMatchStats(
            id: id,
            teamId: teamId,
            matchId: matchId,
            goals: goals,
            possession: possession,
            shots: shots,
            shotsOnTarget: shotsOnTarget
        )
    }
}
#endif
