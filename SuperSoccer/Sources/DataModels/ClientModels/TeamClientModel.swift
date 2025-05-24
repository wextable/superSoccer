//
//  Team.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import Foundation

struct TeamInfo: Identifiable {
    let id: String
    let city: String
    let teamName: String
}

struct Team: Identifiable {
    let id: String
    let info: TeamInfo
    let players: [Player]
}

#if DEBUG
extension TeamInfo {
    static func make(
        id: String = "1",
        city: String = "San Francisco",
        teamName: String = "49ers"
    ) -> TeamInfo {
        return TeamInfo(
            id: id,
            city: city,
            teamName: teamName
        )
    }
}

extension Team {
    static func make(
        id: String = "1",
        info: TeamInfo = .make(),
        players: [Player] = [.make()]
    ) -> Team {
        return Team(
            id: id,
            info: info,
            players: players
        )
    }
}
#endif
