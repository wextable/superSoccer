//
//  CoordinatorResults.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation

// MARK: - Coordinator Results

enum TeamSelectCoordinatorResult: CoordinatorResult {
    case teamSelected(TeamInfo)
    case cancelled
}

// Special result for root-level coordinators
enum SplashCoordinatorResult: CoordinatorResult {
    case splashCompleted
}

// MARK: - State Models

struct NewGameState {
    let selectedTeam: TeamInfo?
    let coachInfo: CoachInfo?
    
    init(selectedTeam: TeamInfo? = nil, coachInfo: CoachInfo? = nil) {
        self.selectedTeam = selectedTeam
        self.coachInfo = coachInfo
    }
}

struct TeamSelectState {
    let teams: [TeamInfo]
    let isLoading: Bool
    
    init(teams: [TeamInfo] = [], isLoading: Bool = false) {
        self.teams = teams
        self.isLoading = isLoading
    }
}

struct MainMenuState {
    let isLoading: Bool
    
    init(isLoading: Bool = false) {
        self.isLoading = isLoading
    }
}

// MARK: - Supporting Models

struct CoachInfo {
    let firstName: String
    let lastName: String
}

struct GameInfo {
    let team: TeamInfo
    let coach: CoachInfo
}

#if DEBUG
extension TeamInfo {
    static func mock() -> TeamInfo {
        return TeamInfo.make()
    }
}
#endif
