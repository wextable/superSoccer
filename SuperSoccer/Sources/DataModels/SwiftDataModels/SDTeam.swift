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
final class SDTeamInfo {
    var id: String
    var city: String
    var teamName: String
    
    init(
        id: String = UUID().uuidString,
        city: String,
        teamName: String
    ) {
        self.id = id
        self.city = city
        self.teamName = teamName
    }
}

@Model
final class SDTeam {
    var id: String
    var info: SDTeamInfo
    var players: [SDPlayer]
    
    init(
        id: String = UUID().uuidString,
        info: SDTeamInfo,
        players: [SDPlayer] = []
    ) {
        self.id = id
        self.info = info
        self.players = players
    }
}

#if DEBUG
extension SDTeamInfo {
    static func make(
        id: String = "1",
        city: String = "Eugene",
        teamName: String = "Duckies"
    ) -> SDTeamInfo {
        return SDTeamInfo(
            id: id,
            city: city,
            teamName: teamName
        )
    }
}

extension SDTeam {
    static func make(
        id: String = "1",
        info: SDTeamInfo = .make(),
        players: [SDPlayer] = [.make()]
    ) -> SDTeam {
        return SDTeam(
            id: id,
            info: info,
            players: players
        )
    }
}
#endif
