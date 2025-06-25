//
//  TeamSelectViewModel+Presentation.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

extension TeamSelectViewModel {
    init(
        clientModels: [TeamInfo]
    ) {
        self.init(
            title: "Select a team",
            teamModels: clientModels.map { TeamThumbnailViewModel(clientModel: $0) }
        )
    }
}

extension TeamThumbnailViewModel {
    init(clientModel: TeamInfo) {
        self.init(
            id: clientModel.id,
            text: clientModel.city + " " + clientModel.teamName
        )
    }
}
