//
//  SwiftDataToClientModelTransforms.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

extension TeamInfoClientModel {
    init(sdTeamInfo: SDTeamInfo) {
        self.teamName = sdTeamInfo.teamName
        self.city = sdTeamInfo.city
    }
}

extension TeamClientModel {
    init(sdTeam: SDTeam) {
        self.info = TeamInfoClientModel(sdTeamInfo: sdTeam.info)
        self.players = sdTeam.players.map { PlayerClientModel(sdPlayer: $0) }
    }
}

extension PlayerClientModel {
    init(sdPlayer: SDPlayer) {
        self.firstName = sdPlayer.firstName
        self.lastName = sdPlayer.lastName
    }
}
