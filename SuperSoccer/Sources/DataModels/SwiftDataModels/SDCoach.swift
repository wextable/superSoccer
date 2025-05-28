//
//  SDCoach.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
// SDCoach.swift

import Foundation
import SwiftData

@Model
final class SDCoach {
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
extension SDCoach {
    static func make(
        id: String = "1",
        firstName: String = "Hugh",
        lastName: String = "Freeze"
    ) -> SDCoach {
        return SDCoach(
            id: id,
            firstName: firstName,
            lastName: lastName
        )
    }
}
#endif
