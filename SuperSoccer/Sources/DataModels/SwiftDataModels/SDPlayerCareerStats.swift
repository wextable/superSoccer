//
//  SDPlayerCareerStats.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDPlayerCareerStats {
    var id: String
    var totalGames: Int
    var totalGoals: Int
    
    // Relationships
    var player: SDPlayer
    
    init(
        id: String = UUID().uuidString,
        totalGames: Int = 0,
        totalGoals: Int = 0,
        player: SDPlayer
    ) {
        self.id = id
        self.totalGames = totalGames
        self.totalGoals = totalGoals
        self.player = player
    }
}

#if DEBUG
extension SDPlayerCareerStats {
    static func make(
        id: String = "1",
        totalGames: Int = 100,
        totalGoals: Int = 25,
        player: SDPlayer = .make()
    ) -> SDPlayerCareerStats {
        return SDPlayerCareerStats(
            id: id,
            totalGames: totalGames,
            totalGoals: totalGoals,
            player: player
        )
    }
}
#endif
