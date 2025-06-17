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
    var age: Int
    var position: String
    
    // Relationships
    var team: SDTeam?
    @Relationship(inverse: \SDContract.player)
    var contracts: [SDContract]
    @Relationship(inverse: \SDPlayerCareerStats.player)
    var careerStats: SDPlayerCareerStats?
    @Relationship(inverse: \SDPlayerSeasonStats.player)
    var seasonStats: [SDPlayerSeasonStats]
    @Relationship(inverse: \SDPlayerMatchStats.player)
    var matchStats: [SDPlayerMatchStats]
    
    init(
        id: String = UUID().uuidString,
        firstName: String,
        lastName: String,
        age: Int,
        position: String
    ) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.position = position
        self.contracts = []
        self.seasonStats = []
        self.matchStats = []
    }
}

#if DEBUG
extension SDPlayer {
    static func make(
        id: String = "1",
        firstName: String = "Bo",
        lastName: String = "Nix",
        age: Int = 25,
        position: String = "Forward",
        team: SDTeam? = nil
    ) -> SDPlayer {
        let player = SDPlayer(
            id: id,
            firstName: firstName,
            lastName: lastName,
            age: age,
            position: position
        )
        player.team = team
        return player
    }
}
#endif
