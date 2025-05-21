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
    var city: String
    var teamName: String
    
    init(
        city: String = "Eugene",
        teamName: String = "Duckies"
    ) {
        self.city = city
        self.teamName = teamName
    }
}

@Model
final class SDTeam {
    var info: SDTeamInfo
    var players: [SDPlayer]
    
    init(
        info: SDTeamInfo = SDTeamInfo(),
        players: [SDPlayer] = []
    ) {
        self.info = info
        self.players = players
    }
}
