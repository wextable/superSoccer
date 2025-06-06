//
//  SDLeague.swift
//  SuperSoccer
//
//  Created by Wesley on 6/4/25.
//

import Foundation
import SwiftData

@Model
final class SDLeague {
    var id: String
    var name: String
    var teams: [SDTeam]
    var userTeamId: String
    
    init(
        id: String = UUID().uuidString,
        name: String,
        teams: [SDTeam] = [],
        userTeamId: String
    ) {
        self.id = id
        self.name = name
        self.teams = teams
        self.userTeamId = userTeamId
    }
}

#if DEBUG
extension SDLeague {
    static func make(
        id: String = "1",
        name: String = "English Premier League",
        teams: [SDTeam] = [.make()],
        userTeamId: String = "1"
    ) -> SDLeague {
        return SDLeague(
            id: id,
            name: name,
            teams: teams,
            userTeamId: userTeamId
        )
    }
}
#endif
