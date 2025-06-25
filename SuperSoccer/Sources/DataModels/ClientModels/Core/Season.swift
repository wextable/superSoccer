//
//  Season.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct Season: Identifiable, Hashable, Equatable {
    let id: String
    let seasonNumber: Int
    let year: Int
    let isCompleted: Bool
    
    // ID-based relationships
    let leagueId: String
    let careerId: String?
    let matchIds: [String]
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension Season {
    static func make(
        id: String = "1",
        seasonNumber: Int = 1,
        year: Int = 2025,
        isCompleted: Bool = false,
        leagueId: String = "1",
        careerId: String? = nil,
        matchIds: [String] = []
    ) -> Season {
        return Season(
            id: id,
            seasonNumber: seasonNumber,
            year: year,
            isCompleted: isCompleted,
            leagueId: leagueId,
            careerId: careerId,
            matchIds: matchIds
        )
    }
}
#endif
