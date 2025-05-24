//
//  TeamDetailViewModel+Presentation.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

extension TeamDetailViewModel {
    init(clientModel: Team) {
        self.init(
            title: "Team Details",
            teamName: clientModel.info.city + " " + clientModel.info.teamName
        )
    }
}
