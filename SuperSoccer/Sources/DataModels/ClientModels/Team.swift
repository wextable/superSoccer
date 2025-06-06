//
//  Team.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import Foundation

struct TeamInfo: Identifiable, Hashable, Equatable {
    let id: String
    let city: String
    let teamName: String
}

struct Team: Identifiable, Hashable, Equatable {
    let id: String
    let coachId: String
    let info: TeamInfo
    let playerIds: [String]
    
    // ID-based relationships
    let leagueId: String?
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
        coachId: String = "1",
        info: TeamInfo = .make(),
        playerIds: [String] = ["1"],
        leagueId: String? = nil
    ) -> Team {
        return Team(
            id: id,
            coachId: coachId,
            info: info,
            playerIds: playerIds,
            leagueId: leagueId
        )
    }
}
#endif
