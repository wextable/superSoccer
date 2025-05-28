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
                    interactor.eventBus.send(.teamSelected(teamId: teamModel.id))
                }
        }
        .navigationTitle(interactor.viewModel.title)
    }
}

#if DEBUG
extension TeamSelectViewModel {
    static func make(
        title: String = "Auburn Tigers",
        teamModels: [TeamThumbnailViewModel] = [.make(), .make(text: "Alabama Crimson Tide Losers")]
    ) -> Self {
        self.init(
            title: title,
            teamModels: teamModels
        )
    }
}
#endif
