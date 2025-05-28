//
//  Player.swift
//  SuperSoccer
//
//  Created by Wesley on 5/16/25.
//

import Foundation

struct Player: Identifiable {
    let id: String
    let firstName: String
    let lastName: String
}

#if DEBUG
extension Player {
    static func make(
        id: String = "1",
        firstName: String = "Bo",
        lastName: String = "Nix"
    ) -> Player {
        return Player(
            id: id,
            firstName: firstName,
            lastName: lastName
        )
    }
}
#endif
