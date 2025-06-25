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

struct TeamSelectView: View {
    let interactor: any TeamSelectInteractorProtocol
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        List(interactor.viewModel.teamModels) { teamModel in
            TeamThumbnailView(viewModel: teamModel)
                .onTapGesture {
                    interactor.eventBus.send(.teamSelected(teamInfoId: teamModel.id))
                }
                .listRowBackground(theme.colors.background)
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .background(theme.colors.background)
        .navigationTitle(interactor.viewModel.title)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .scrollContentBackground(.hidden)
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
