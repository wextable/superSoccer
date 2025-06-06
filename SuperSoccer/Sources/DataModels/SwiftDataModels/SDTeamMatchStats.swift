//
//  SDTeamMatchStats.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDTeamMatchStats {
    var id: String
    var goals: Int
    var possession: Int
    var shots: Int
    var shotsOnTarget: Int
    
    // Relationships
    var team: SDTeam
    var match: SDMatch
    
    init(
        id: String = UUID().uuidString,
        goals: Int = 0,
        possession: Int = 50,
        shots: Int = 0,
        shotsOnTarget: Int = 0,
        team: SDTeam,
        match: SDMatch
    ) {
        self.id = id
        self.goals = goals
        self.possession = possession
        self.shots = shots
        self.shotsOnTarget = shotsOnTarget
        self.team = team
        self.match = match
    }
}

#if DEBUG
extension SDTeamMatchStats {
    static func make(
        id: String = "1",
        goals: Int = 2,
        possession: Int = 60,
        shots: Int = 15,
        shotsOnTarget: Int = 8,
        team: SDTeam = .make(),
        match: SDMatch = .make()
    ) -> SDTeamMatchStats {
        return SDTeamMatchStats(
            id: id,
            goals: goals,
            possession: possession,
            shots: shots,
            shotsOnTarget: shotsOnTarget,
            team: team,
            match: match
        )
    }
}
#endif
