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

//extension TeamSelectorViewModel {
//    init(
//        clientModel: TeamInfo?,
//        action: @escaping () -> Void
//    ) {
//        if let clientModel {
//            self.init(
//                title: "Team: \(clientModel.city) \(clientModel.teamName)",
//                buttonTitle: "Change team",
//                action: action
//            )
//        } else {
//            self.init(
//                title: "Team: ",
//                buttonTitle: "Select a team",
//                action: action
//            )
//        }
//    }
//}
