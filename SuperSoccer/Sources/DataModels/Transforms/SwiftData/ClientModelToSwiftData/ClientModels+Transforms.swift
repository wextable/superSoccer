//
//  ClientModels+Transforms.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

extension TeamInfo {
    init(sdTeamInfo: SDTeamInfo) {
        self.id = sdTeamInfo.id
        self.teamName = sdTeamInfo.teamName
        self.city = sdTeamInfo.city
    }
}

extension Coach {
    init(sdCoach: SDCoach) {
        self.id = sdCoach.id
        self.firstName = sdCoach.firstName
        self.lastName = sdCoach.lastName
    }
}

extension Player {
    init(sdPlayer: SDPlayer) {
        self.id = sdPlayer.id
        self.firstName = sdPlayer.firstName
        self.lastName = sdPlayer.lastName
    }
}

extension Team {
    init(sdTeam: SDTeam) {
        self.id = sdTeam.id
        self.coach = Coach(sdCoach: sdTeam.coach)
        self.info = TeamInfo(sdTeamInfo: sdTeam.info)
        self.players = sdTeam.players.map { Player(sdPlayer: $0) }
    }
}
