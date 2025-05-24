//
//  SDPlayer.swift
//  SuperSoccer
//
//  Created by Wesley on 5/16/25.
//

import Foundation
import SwiftData

// @Model is a SwiftData macro that indicates this class is a persistable model
// The @Model macro is crucial - it automatically generates all the necessary code for persistence, 
// similar to Core Data's @NSManaged but much simpler
// Properties in a SwiftData model are automatically persisted
@Model
final class SDPlayer {
    var id: String
    var firstName: String
    var lastName: String
    
    init(
        id: String = UUID().uuidString,
        firstName: String,
        lastName: String
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
    }
}

#if DEBUG
extension SDPlayer {
    static func make(
        id: String = "1",
        firstName: String = "Bo",
        lastName: String = "Nix"
    ) -> SDPlayer {
        return SDPlayer(
            id: id,
            firstName: firstName,
            lastName: lastName
        )
    }
}
#endif
