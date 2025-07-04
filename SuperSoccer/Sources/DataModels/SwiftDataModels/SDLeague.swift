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
    
    // Relationships
    @Relationship(inverse: \SDTeam.league)
    var teams: [SDTeam]
    @Relationship(inverse: \SDSeason.league)
    var seasons: [SDSeason]
    
    init(
        id: String = UUID().uuidString,
        name: String,
        teams: [SDTeam] = []
    ) {
        self.id = id
        self.name = name
        self.teams = teams
        self.seasons = []
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension SDLeague {
    static func make(
        id: String = "1",
        name: String = "English Premier League",
        teams: [SDTeam] = [.make()]
    ) -> SDLeague {
        return SDLeague(
            id: id,
            name: name,
            teams: teams
        )
    }
}
#endif
