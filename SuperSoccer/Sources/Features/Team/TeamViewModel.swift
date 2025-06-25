//
//  TeamViewModel.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import Foundation

struct TeamHeaderViewModel {
    let teamName: String
    let teamLogo: String // For now, we'll use team initials or a simple identifier
    let starRating: Double // Calculated from team performance
    let leagueStanding: String // e.g., "3rd Place"
    let teamRecord: String // e.g., "15W-3L-4D"
    let coachName: String
}

struct TeamViewModel {
    let coachName: String
    let teamName: String
    let header: TeamHeaderViewModel
    let playerRows: [PlayerRowViewModel]
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamHeaderViewModel {
    static func make(
        teamName: String = "Mock Team",
        teamLogo: String = "MT",
        starRating: Double = 4.2,
        leagueStanding: String = "3rd Place",
        teamRecord: String = "15W-3L-4D",
        coachName: String = "John Smith"
    ) -> TeamHeaderViewModel {
        TeamHeaderViewModel(
            teamName: teamName,
            teamLogo: teamLogo,
            starRating: starRating,
            leagueStanding: leagueStanding,
            teamRecord: teamRecord,
            coachName: coachName
        )
    }
}

extension TeamViewModel {
    static func make(
        coachName: String = "Mock Coach",
        teamName: String = "Mock Team",
        header: TeamHeaderViewModel = .make(),
        playerRows: [PlayerRowViewModel] = [
            .make(playerName: "Mock Player 1", position: "GK"),
            .make(playerName: "Mock Player 2", position: "CB"),
            .make(playerName: "Mock Player 3", position: "ST")
        ]
    ) -> TeamViewModel {
        TeamViewModel(
            coachName: coachName,
            teamName: teamName,
            header: header,
            playerRows: playerRows
        )
    }
}
#endif
