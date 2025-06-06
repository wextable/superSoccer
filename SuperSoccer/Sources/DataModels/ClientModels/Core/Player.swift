//
//  Player.swift
//  SuperSoccer
//
//  Created by Wesley on 5/16/25.
//

import Foundation

struct Player: Identifiable, Hashable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
    let age: Int
    let position: String
    
    // ID-based relationships
    let teamId: String?
}

#if DEBUG
extension Player {
    static func make(
        id: String = "1",
        firstName: String = "Bo",
        lastName: String = "Nix",
        age: Int = 25,
        position: String = "Forward",
        teamId: String? = nil
    ) -> Player {
        return Player(
            id: id,
            firstName: firstName,
            lastName: lastName,
            age: age,
            position: position,
            teamId: teamId
        )
    }
}
#endif
