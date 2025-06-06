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
    var date: Date
    var seasonNumber: Int
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
        date: Date,
        seasonNumber: Int,
        isCompleted: Bool = false,
        homeTeam: SDTeam,
        awayTeam: SDTeam
    ) {
        self.id = id
        self.date = date
        self.seasonNumber = seasonNumber
        self.isCompleted = isCompleted
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.playerStats = []
        self.teamStats = []
    }
}

#if DEBUG
extension SDMatch {
    static func make(
        id: String = "1",
        date: Date = Date(),
        seasonNumber: Int = 1,
        isCompleted: Bool = false,
        homeTeam: SDTeam = .make(),
        awayTeam: SDTeam = .make()
    ) -> SDMatch {
        return SDMatch(
            id: id,
            date: date,
            seasonNumber: seasonNumber,
            isCompleted: isCompleted,
            homeTeam: homeTeam,
            awayTeam: awayTeam
        )
    }
}
#endif
