//
//  SDSeason.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDSeason {
    var id: String
    var seasonNumber: Int
    var year: Int
    var isCompleted: Bool
    
    // Relationships
    var career: SDCareer?
    var league: SDLeague
    @Relationship(inverse: \SDMatch.season)
    var matches: [SDMatch]
    
    init(
        id: String = UUID().uuidString,
        seasonNumber: Int,
        year: Int,
        isCompleted: Bool = false,
        league: SDLeague,
        matches: [SDMatch] = []
    ) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.year = year
        self.isCompleted = isCompleted
        self.league = league
        self.matches = matches
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension SDSeason {
    static func make(
        id: String = "1",
        seasonNumber: Int = 1,
        year: Int = 2025,
        isCompleted: Bool = false,
        league: SDLeague = .make(),
        matches: [SDMatch] = [],
        career: SDCareer? = nil
    ) -> SDSeason {
        let season =  SDSeason(
            id: id,
            seasonNumber: seasonNumber,
            year: year,
            isCompleted: isCompleted,
            league: league,
            matches: matches
        )
        season.career = career
        return season
    }
}
#endif
