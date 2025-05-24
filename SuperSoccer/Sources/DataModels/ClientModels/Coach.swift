//
//  Coach.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

struct Coach: Identifiable {
    let id: String
    let firstName: String
    let lastName: String
}

#if DEBUG
extension Coach {
    static func make(
        id: String = "1",
        firstName: String = "Bo",
        lastName: String = "Nix"
    ) -> Coach {
        return Coach(
            id: id,
            firstName: firstName,
            lastName: lastName
        )
    }
}
#endif
