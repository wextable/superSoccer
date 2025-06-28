//
//  TeamView.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

@MainActor
protocol TeamViewPresenter: AnyObject {
    var viewModel: TeamViewModel { get }
    func loadTeamData()
    func playerRowTapped(_ playerId: String)
}

struct TeamViewModel {
    var coachName: String = ""
    var teamName: String = ""
    var header: TeamHeaderViewModel = TeamHeaderViewModel()
    var playerRows: [PlayerRowViewModel] = []
}

struct TeamView: View {
    let presenter: TeamViewPresenter
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.large) {
                TeamHeaderView(viewModel: presenter.viewModel.header)
                
                playersSection
                
                Spacer()
            }
            .padding(theme.spacing.large)
        }
        .background(theme.colors.background)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            presenter.loadTeamData()
        }
    }
    
    private var playersSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            SSTitle.title3("Players")
            
            LazyVStack(spacing: theme.spacing.small) {
                ForEach(presenter.viewModel.playerRows, id: \.playerId) { playerRowViewModel in
                    PlayerRowView(
                        viewModel: playerRowViewModel,
                        onTap: {
                            presenter.playerRowTapped(playerRowViewModel.playerId)
                        }
                    )
                }
            }
        }
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamViewModel {
    static func make(
        coachName: String = "Mock Coach",
        teamName: String = "Mock Team",
        header: TeamHeaderViewModel = .make(),
        playerRows: [PlayerRowViewModel] = [
            .make(playerName: "Mock Player 1", position: "GK"),
            .make(playerName: "Mock Player 2", position: "CB"),
            .make(playerName: "Mock Player 3", position: "ST")
        ]
    ) -> TeamViewModel {
        TeamViewModel(
            coachName: coachName,
            teamName: teamName,
            header: header,
            playerRows: playerRows
        )
    }
}

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SSThemeProvider {
                TeamView(presenter: MockTeamInteractor())
            }
        }
    }
}
#endif
