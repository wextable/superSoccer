//
//  TeamClientModel.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import Foundation

struct TeamInfoClientModel: Identifiable {
    let id = UUID().uuidString
    let city: String
    let teamName: String
}

struct TeamClientModel: Identifiable {
    let id = UUID().uuidString
    let info: TeamInfoClientModel
    let players: [PlayerClientModel]
}

#if DEBUG
extension TeamInfoClientModel {
    static func make(
        city: String = "San Francisco",
        teamName: String = "49ers"
    ) -> TeamInfoClientModel {
        return TeamInfoClientModel(
            city: city,
            teamName: teamName
        )
    }
}

extension TeamClientModel {
    static func make(
        info: TeamInfoClientModel = .make(),
        players: [PlayerClientModel] = [.make()]
    ) -> TeamClientModel {
        return TeamClientModel(
            info: info,
            players: players
        )
    }
}
#endif
