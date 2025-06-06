//
//  SDCareer.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDCareer {
    var id: String
    
    // Relationships
    var coach: SDCoach
    var userTeam: SDTeam
    var currentSeason: SDSeason
    @Relationship(inverse: \SDSeason.career)
    var seasons: [SDSeason]
    
    init(
        id: String = UUID().uuidString,
        coach: SDCoach,
        userTeam: SDTeam,
        currentSeason: SDSeason,
        seasons: [SDSeason] = []
    ) {
        self.id = id
        self.coach = coach
        self.userTeam = userTeam
        self.currentSeason = currentSeason
        self.seasons = seasons
    }
}

#if DEBUG
extension SDCareer {
    static func make(
        id: String = "1",
        coach: SDCoach = .make(),
        userTeam: SDTeam = .make(),
        currentSeason: SDSeason = .make(),
        seasons: [SDSeason] = []
    ) -> SDCareer {
        return SDCareer(
            id: id,
            coach: coach,
            userTeam: userTeam,
            currentSeason: currentSeason,
            seasons: seasons
        )
    }
}
#endif
