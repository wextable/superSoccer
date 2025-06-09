//
//  CreateNewCareerRequest.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct CreateNewCareerRequest: Hashable, Equatable {
    let coachFirstName: String
    let coachLastName: String
    let selectedTeamInfoId: String
    let leagueName: String
    let seasonYear: Int
}

#if DEBUG
extension CreateNewCareerRequest {
    static func make(
        coachFirstName: String = "John",
        coachLastName: String = "Manager",
        selectedTeamInfoId: String = "1",
        leagueName: String = "English Premier League",
        seasonYear: Int = 2025
    ) -> CreateNewCareerRequest {
        return CreateNewCareerRequest(
            coachFirstName: coachFirstName,
            coachLastName: coachLastName,
            selectedTeamInfoId: selectedTeamInfoId,
            leagueName: leagueName,
            seasonYear: seasonYear
        )
    }
}
#endif
