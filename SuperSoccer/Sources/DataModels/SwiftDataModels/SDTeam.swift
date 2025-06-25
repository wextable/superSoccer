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
    
    // Relationships
    var info: SDTeamInfo
    var coach: SDCoach
    var league: SDLeague?
    @Relationship(inverse: \SDPlayer.team)
    var players: [SDPlayer]
    @Relationship(inverse: \SDContract.team)
    var contracts: [SDContract]
    @Relationship(inverse: \SDTeamCareerStats.team)
    var careerStats: SDTeamCareerStats?
    @Relationship(inverse: \SDTeamSeasonStats.team)
    var seasonStats: [SDTeamSeasonStats]
    @Relationship(inverse: \SDTeamMatchStats.team)
    var matchStats: [SDTeamMatchStats]
    
    init(
        id: String = UUID().uuidString,
        info: SDTeamInfo,
        coach: SDCoach,
        players: [SDPlayer] = []
    ) {
        self.id = id
        self.info = info
        self.coach = coach
        self.players = players
        self.contracts = []
        self.seasonStats = []
        self.matchStats = []
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension SDTeam {
    static func make(
        id: String = "1",
        info: SDTeamInfo = .make(),
        coach: SDCoach = .make(),
        players: [SDPlayer] = [.make()],
        league: SDLeague? = nil
    ) -> SDTeam {
        let team = SDTeam(
            id: id,
            info: info,
            coach: coach,
            players: players
        )
        team.league = league
        return team
    }
}
#endif
