//
//  Contract.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct Contract: Identifiable, Hashable, Equatable {
    let id: String
    let startDate: Date
    let endDate: Date
    let salary: Int
    let isActive: Bool
    
    // ID-based relationships
    let playerId: String
    let teamId: String
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension Contract {
    static func make(
        id: String = "1",
        startDate: Date = Date(),
        endDate: Date = Calendar.current.date(byAdding: .year, value: 2, to: Date()) ?? Date(),
        salary: Int = 50000,
        isActive: Bool = true,
        playerId: String = "1",
        teamId: String = "1"
    ) -> Contract {
        return Contract(
            id: id,
            startDate: startDate,
            endDate: endDate,
            salary: salary,
            isActive: isActive,
            playerId: playerId,
            teamId: teamId
        )
    }
}
#endif
