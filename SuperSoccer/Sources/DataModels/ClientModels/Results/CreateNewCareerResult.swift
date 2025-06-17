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
        careerId: String = "test-career",
        coachId: String = "test-coach",
        userTeamId: String = "test-team",
        leagueId: String = "test-league",
        currentSeasonId: String = "test-season",
        allTeamIds: [String] = ["test-team"],
        allPlayerIds: [String] = ["test-player"]
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
