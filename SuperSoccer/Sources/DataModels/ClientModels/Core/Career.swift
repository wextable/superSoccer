//
//  Career.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct Career: Identifiable, Hashable, Equatable {
    let id: String
    
    // ID-based relationships
    let coachId: String
    let userTeamId: String
    let currentSeasonId: String
    let seasonIds: [String]
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension Career {
    static func make(
        id: String = "1",
        coachId: String = "1",
        userTeamId: String = "1",
        currentSeasonId: String = "1",
        seasonIds: [String] = ["1"]
    ) -> Career {
        return Career(
            id: id,
            coachId: coachId,
            userTeamId: userTeamId,
            currentSeasonId: currentSeasonId,
            seasonIds: seasonIds
        )
    }
}
#endif
