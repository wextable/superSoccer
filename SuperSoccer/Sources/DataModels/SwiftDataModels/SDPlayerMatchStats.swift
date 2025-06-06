//
//  SDPlayerMatchStats.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDPlayerMatchStats {
    var id: String
    var goals: Int
    var minutesPlayed: Int
    
    // Relationships
    var player: SDPlayer
    var match: SDMatch
    
    init(
        id: String = UUID().uuidString,
        goals: Int = 0,
        minutesPlayed: Int = 0,
        player: SDPlayer,
        match: SDMatch
    ) {
        self.id = id
        self.goals = goals
        self.minutesPlayed = minutesPlayed
        self.player = player
        self.match = match
    }
}

#if DEBUG
extension SDPlayerMatchStats {
    static func make(
        id: String = "1",
        goals: Int = 1,
        minutesPlayed: Int = 90,
        player: SDPlayer = .make(),
        match: SDMatch = .make()
    ) -> SDPlayerMatchStats {
        return SDPlayerMatchStats(
            id: id,
            goals: goals,
            minutesPlayed: minutesPlayed,
            player: player,
            match: match
        )
    }
}
#endif
