//
//  SDContract.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation
import SwiftData

@Model
final class SDContract {
    var id: String
    var startDate: Date
    var endDate: Date
    var salary: Int
    var isActive: Bool
    
    // Relationships
    var player: SDPlayer
    var team: SDTeam
    
    init(
        id: String = UUID().uuidString,
        startDate: Date,
        endDate: Date,
        salary: Int,
        isActive: Bool = true,
        player: SDPlayer,
        team: SDTeam
    ) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
        self.salary = salary
        self.isActive = isActive
        self.player = player
        self.team = team
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension SDContract {
    static func make(
        id: String = "1",
        startDate: Date = Date(),
        endDate: Date = Calendar.current.date(byAdding: .year, value: 3, to: Date()) ?? Date(),
        salary: Int = 50000,
        isActive: Bool = true,
        player: SDPlayer = .make(),
        team: SDTeam = .make()
    ) -> SDContract {
        return SDContract(
            id: id,
            startDate: startDate,
            endDate: endDate,
            salary: salary,
            isActive: isActive,
            player: player,
            team: team
        )
    }
}
#endif
