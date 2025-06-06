//
//  PlayerStats.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

// Career stats for a player
struct PlayerCareerStats: Identifiable, Hashable, Equatable {
    let id: String
    let playerId: String
    let totalGames: Int
    let totalGoals: Int
}

// Season stats for a player
struct PlayerSeasonStats: Identifiable, Hashable, Equatable {
    let id: String
    let playerId: String
    let seasonNumber: Int
    let games: Int
    let goals: Int
}

// Match stats for a player
struct PlayerMatchStats: Identifiable, Hashable, Equatable {
    let id: String
    let playerId: String
    let matchId: String
    let goals: Int
    let minutesPlayed: Int
}

#if DEBUG
extension PlayerCareerStats {
    static func make(
        id: String = "1",
        playerId: String = "1",
        totalGames: Int = 50,
        totalGoals: Int = 15
    ) -> PlayerCareerStats {
        return PlayerCareerStats(
            id: id,
            playerId: playerId,
            totalGames: totalGames,
            totalGoals: totalGoals
        )
    }
}

extension PlayerSeasonStats {
    static func make(
        id: String = "1",
        playerId: String = "1",
        seasonNumber: Int = 1,
        games: Int = 20,
        goals: Int = 8
    ) -> PlayerSeasonStats {
        return PlayerSeasonStats(
            id: id,
            playerId: playerId,
            seasonNumber: seasonNumber,
            games: games,
            goals: goals
        )
    }
}

extension PlayerMatchStats {
    static func make(
        id: String = "1",
        playerId: String = "1",
        matchId: String = "1",
        goals: Int = 1,
        minutesPlayed: Int = 90
    ) -> PlayerMatchStats {
        return PlayerMatchStats(
            id: id,
            playerId: playerId,
            matchId: matchId,
            goals: goals,
            minutesPlayed: minutesPlayed
        )
    }
}
#endif
