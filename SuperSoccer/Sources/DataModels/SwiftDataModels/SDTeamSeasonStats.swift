//
//  SDTeamSeasonStats.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDTeamSeasonStats {
    var id: String
    var seasonNumber: Int
    var games: Int
    var wins: Int
    var draws: Int
    var losses: Int
    var points: Int
    var goalsFor: Int
    var goalsAgainst: Int
    
    // Relationships
    var team: SDTeam
    
    init(
        id: String = UUID().uuidString,
        seasonNumber: Int,
        games: Int = 0,
        wins: Int = 0,
        draws: Int = 0,
        losses: Int = 0,
        points: Int = 0,
        goalsFor: Int = 0,
        goalsAgainst: Int = 0,
        team: SDTeam
    ) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.games = games
        self.wins = wins
        self.draws = draws
        self.losses = losses
        self.points = points
        self.goalsFor = goalsFor
        self.goalsAgainst = goalsAgainst
        self.team = team
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension SDTeamSeasonStats {
    static func make(
        id: String = "1",
        seasonNumber: Int = 1,
        games: Int = 38,
        wins: Int = 25,
        draws: Int = 8,
        losses: Int = 5,
        points: Int = 83,
        goalsFor: Int = 0,
        goalsAgainst: Int = 0,
        team: SDTeam = .make()
    ) -> SDTeamSeasonStats {
        return SDTeamSeasonStats(
            id: id,
            seasonNumber: seasonNumber,
            games: games,
            wins: wins,
            draws: draws,
            losses: losses,
            points: points,
            goalsFor: goalsFor,
            goalsAgainst: goalsAgainst,
            team: team
        )
    }
}
#endif
