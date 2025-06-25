//
//  SDPlayerSeasonStats.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDPlayerSeasonStats {
    var id: String
    var seasonNumber: Int
    var games: Int
    var goals: Int
    
    // Relationships
    var player: SDPlayer
    
    init(
        id: String = UUID().uuidString,
        seasonNumber: Int,
        games: Int = 0,
        goals: Int = 0,
        player: SDPlayer
    ) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.games = games
        self.goals = goals
        self.player = player
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension SDPlayerSeasonStats {
    static func make(
        id: String = "1",
        seasonNumber: Int = 1,
        games: Int = 30,
        goals: Int = 8,
        player: SDPlayer = .make()
    ) -> SDPlayerSeasonStats {
        return SDPlayerSeasonStats(
            id: id,
            seasonNumber: seasonNumber,
            games: games,
            goals: goals,
            player: player
        )
    }
}
#endif
