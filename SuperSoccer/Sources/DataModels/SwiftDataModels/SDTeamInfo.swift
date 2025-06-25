//
//  SDTeamInfo.swift
//  SuperSoccer
//
//  Created by Wesley on 6/4/25.
//

import Foundation
import SwiftData

@Model
final class SDTeamInfo {
    var id: String
    var city: String
    var teamName: String
    
    init(
        id: String = UUID().uuidString,
        city: String,
        teamName: String
    ) {
        self.id = id
        self.city = city
        self.teamName = teamName
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension SDTeamInfo {
    static func make(
        id: String = "1",
        city: String = "Eugene",
        teamName: String = "Duckies"
    ) -> SDTeamInfo {
        return SDTeamInfo(
            id: id,
            city: city,
            teamName: teamName
        )
    }
}
#endif
