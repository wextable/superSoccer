//
//  Match.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct Match: Identifiable, Hashable, Equatable {
    let id: String
    let isCompleted: Bool
    
    // ID-based relationships
    let homeTeamId: String
    let awayTeamId: String
    let seasonId: String?
}

#if DEBUG
extension Match {
    static func make(
        id: String = "1",
        isCompleted: Bool = false,
        homeTeamId: String = "1",
        awayTeamId: String = "2",
        seasonId: String? = "1"
    ) -> Match {
        return Match(
            id: id,
            isCompleted: isCompleted,
            homeTeamId: homeTeamId,
            awayTeamId: awayTeamId,
            seasonId: seasonId
        )
    }
}
#endif
