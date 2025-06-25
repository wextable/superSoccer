//
//  Coach.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

struct Coach: Identifiable, Hashable, Equatable {
    let id: String
    let firstName: String
    let lastName: String
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension Coach {
    static func make(
        id: String = "1",
        firstName: String = "Hugh",
        lastName: String = "Freeze"
    ) -> Coach {
        return Coach(
            id: id,
            firstName: firstName,
            lastName: lastName
        )
    }
}
#endif
