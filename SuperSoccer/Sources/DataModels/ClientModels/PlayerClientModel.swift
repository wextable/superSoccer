//
//  PlayerClientModel.swift
//  SuperSoccer
//
//  Created by Wesley on 5/16/25.
//

import Foundation

struct PlayerClientModel: Identifiable {
    let id = UUID()
    let firstName: String
    let lastName: String
}

#if DEBUG
extension PlayerClientModel {
    static func make(
        firstName: String = "Bo",
        lastName: String = "Nix"
    ) -> PlayerClientModel {
        return PlayerClientModel(
            firstName: firstName,
            lastName: lastName
        )
    }
}
#endif
