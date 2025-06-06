//
//  Match.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct Match: Identifiable, Hashable, Equatable {
    let id: String
    let date: Date
    let seasonNumber: Int
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
        date: Date = Date(),
        seasonNumber: Int = 1,
        isCompleted: Bool = false,
        homeTeamId: String = "1",
        awayTeamId: String = "2",
        seasonId: String? = "1"
    ) -> Match {
        return Match(
            id: id,
            date: date,
            seasonNumber: seasonNumber,
            isCompleted: isCompleted,
            homeTeamId: homeTeamId,
            awayTeamId: awayTeamId,
            seasonId: seasonId
        )
    }
}
#endif
