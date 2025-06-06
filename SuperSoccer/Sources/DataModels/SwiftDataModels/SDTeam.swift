//
//  SDTeam.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Foundation
import SwiftData

// @Model is a SwiftData macro that indicates this class is a persistable model
// The @Model macro is crucial - it automatically generates all the necessary code for persistence, 
// similar to Core Data's @NSManaged but much simpler
// Properties in a SwiftData model are automatically persisted

@Model
final class SDTeam {
    var id: String
    var info: SDTeamInfo
    var coach: SDCoach
    var players: [SDPlayer]
    
    init(
        id: String = UUID().uuidString,
        coach: SDCoach,
        info: SDTeamInfo,
        players: [SDPlayer] = []
    ) {
        self.id = id
        self.coach = coach
        self.info = info
        self.players = players
    }
}

#if DEBUG
extension SDTeam {
    static func make(
        id: String = "1",
        coach: SDCoach = .make(),
        info: SDTeamInfo = .make(),
        players: [SDPlayer] = [.make()]
    ) -> SDTeam {
        return SDTeam(
            id: id,
            coach: coach,
            info: info,
            players: players
        )
    }
}
#endif
