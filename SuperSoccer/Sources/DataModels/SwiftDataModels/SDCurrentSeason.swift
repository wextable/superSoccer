//
//  SDCurrentSeason.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDCurrentSeason {
    var id: String
    var seasonNumber: Int
    
    // Relationships
    var career: SDCareer?
    @Relationship(inverse: \SDLeague.currentSeasons)
    var league: SDLeague
    
    init(
        id: String = UUID().uuidString,
        seasonNumber: Int,
        league: SDLeague
    ) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.league = league
    }
}

#if DEBUG
extension SDCurrentSeason {
    static func make(
        id: String = "1",
        seasonNumber: Int = 1,
        league: SDLeague = .make()
    ) -> SDCurrentSeason {
        return SDCurrentSeason(
            id: id,
            seasonNumber: seasonNumber,
            league: league
        )
    }
}
#endif
