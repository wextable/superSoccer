//
//  CreateNewCareerResult.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct CreateNewCareerResult: Hashable, Equatable {
    let careerId: String
    let coachId: String
    let userTeamId: String
    let leagueId: String
    let currentSeasonId: String
    let allTeamIds: [String]
    let allPlayerIds: [String]
}

#if DEBUG
extension CreateNewCareerResult {
    static func make(
        careerId: String = "1",
        coachId: String = "1",
        userTeamId: String = "1",
        leagueId: String = "1",
        currentSeasonId: String = "1",
        allTeamIds: [String] = ["1", "2", "3", "4"],
        allPlayerIds: [String] = ["1", "2", "3", "4"]
    ) -> CreateNewCareerResult {
        return CreateNewCareerResult(
            careerId: careerId,
            coachId: coachId,
            userTeamId: userTeamId,
            leagueId: leagueId,
            currentSeasonId: currentSeasonId,
            allTeamIds: allTeamIds,
            allPlayerIds: allPlayerIds
        )
    }
}
#endif
