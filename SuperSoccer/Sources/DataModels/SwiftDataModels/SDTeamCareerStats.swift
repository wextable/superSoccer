//
//  SDTeamCareerStats.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDTeamCareerStats {
    var id: String
    var totalGames: Int
    var totalWins: Int
    var totalDraws: Int
    var totalLosses: Int
    
    // Relationships
    var team: SDTeam
    
    init(
        id: String = UUID().uuidString,
        totalGames: Int = 0,
        totalWins: Int = 0,
        totalDraws: Int = 0,
        totalLosses: Int = 0,
        team: SDTeam
    ) {
        self.id = id
        self.totalGames = totalGames
        self.totalWins = totalWins
        self.totalDraws = totalDraws
        self.totalLosses = totalLosses
        self.team = team
    }
}

#if DEBUG
extension SDTeamCareerStats {
    static func make(
        id: String = "1",
        totalGames: Int = 200,
        totalWins: Int = 120,
        totalDraws: Int = 40,
        totalLosses: Int = 40,
        team: SDTeam = .make()
    ) -> SDTeamCareerStats {
        return SDTeamCareerStats(
            id: id,
            totalGames: totalGames,
            totalWins: totalWins,
            totalDraws: totalDraws,
            totalLosses: totalLosses,
            team: team
        )
    }
}
#endif
