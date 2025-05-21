//
//  TeamSelectView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import SwiftUI

struct TeamSelectViewModel {
    let title: String
    let teamModels: [TeamThumbnailViewModel]
}

struct TeamSelectView<Interactor: TeamSelectInteractorProtocol>: View {
    let interactor: Interactor
    
    var body: some View {
        List(interactor.viewModel.teamModels) { teamModel in
            TeamThumbnailView(viewModel: teamModel)
                .onTapGesture {
                    interactor.eventBus.send(.teamSelected(teamInfoId: teamModel.teamInfoId))
                }
        }
        .navigationTitle(interactor.viewModel.title)
    }
}

//#Preview {
//    let clientModels = [TeamInfoClientModel.make()]
//    let interactor = TeamSelectInteractor(clientModels: clientModels)
//    TeamSelectView(interactor: interactor)
//}
