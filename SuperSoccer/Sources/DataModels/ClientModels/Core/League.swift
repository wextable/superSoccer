//
//  League.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct League: Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    
    // ID-based relationships
    let teamIds: [String]
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension League {
    static func make(
        id: String = "1",
        name: String = "English Premier League",
        teamIds: [String] = ["1", "2", "3", "4"]
    ) -> League {
        return League(
            id: id,
            name: name,
            teamIds: teamIds
        )
    }
}
#endif
