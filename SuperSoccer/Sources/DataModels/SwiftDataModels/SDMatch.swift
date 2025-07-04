//
//  SDMatch.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDMatch {
    var id: String
    var isCompleted: Bool
    
    // Relationships
    var homeTeam: SDTeam
    var awayTeam: SDTeam
    var season: SDSeason?
    @Relationship(inverse: \SDPlayerMatchStats.match)
    var playerStats: [SDPlayerMatchStats]
    @Relationship(inverse: \SDTeamMatchStats.match)
    var teamStats: [SDTeamMatchStats]
    
    init(
        id: String = UUID().uuidString,
        isCompleted: Bool = false,
        homeTeam: SDTeam,
        awayTeam: SDTeam
    ) {
        self.id = id
        self.isCompleted = isCompleted
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.playerStats = []
        self.teamStats = []
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension SDMatch {
    static func make(
        id: String = "1",
        isCompleted: Bool = false,
        homeTeam: SDTeam = .make(),
        awayTeam: SDTeam = .make(),
        season: SDSeason? = nil
    ) -> SDMatch {
        let match = SDMatch(
            id: id,
            isCompleted: isCompleted,
            homeTeam: homeTeam,
            awayTeam: awayTeam
        )
        match.season = season
        return match
    }
}
#endif
