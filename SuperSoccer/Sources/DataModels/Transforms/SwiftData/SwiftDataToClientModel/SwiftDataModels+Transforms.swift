//
//  SwiftDataModels+Transforms.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

//extension SDTeamInfo {
//    convenience init(clientModel: TeamInfo) {
//        self.init(
//            city: clientModel.city,
//            teamName: clientModel.teamName
//        )
//    }
//}
//
//extension SDCoach {
//    convenience init(clientModel: Coach) {
//        self.init(
//            firstName: clientModel.firstName,
//            lastName: clientModel.lastName
//        )
//    }
//}
//
//extension SDPlayer {
//    convenience init(clientModel: Player) {
//        self.init(
//            firstName: clientModel.firstName,
//            lastName: clientModel.lastName,
//            age: 22,
//            position: "Forward"
//        )
//    }
//}
//
//extension SDTeam {
//    convenience init(clientModel: Team) {
//        self.init(
//            info: SDTeamInfo(clientModel: clientModel.info),
//            coach: SDCoach(clientModel: clientModel.coach),
//            players: clientModel.players.map { SDPlayer(clientModel: $0) }
//        )
//    }
//}
