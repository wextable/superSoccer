//
//  PlayerRatings.swift
//  SuperSoccer
//
//  Created by Wesley on 6/6/25.
//

import Foundation

struct PlayerRatings: Identifiable, Hashable, Equatable {
    let id: String
    let playerId: String
    
    // Core ratings for simulation
    let overall: Int
    let pace: Int
    let shooting: Int
    let passing: Int
    let defending: Int
    let physicality: Int
    
    // Specialized ratings
    let finishing: Int
    let crossing: Int
    let tackling: Int
    let positioning: Int
}

#if DEBUG
extension PlayerRatings {
    static func make(
        id: String = "1",
        playerId: String = "1",
        overall: Int = 75,
        pace: Int = 70,
        shooting: Int = 80,
        passing: Int = 75,
        defending: Int = 60,
        physicality: Int = 70,
        finishing: Int = 85,
        crossing: Int = 65,
        tackling: Int = 55,
        positioning: Int = 80
    ) -> PlayerRatings {
        return PlayerRatings(
            id: id,
            playerId: playerId,
            overall: overall,
            pace: pace,
            shooting: shooting,
            passing: passing,
            defending: defending,
            physicality: physicality,
            finishing: finishing,
            crossing: crossing,
            tackling: tackling,
            positioning: positioning
        )
    }
}
#endif
