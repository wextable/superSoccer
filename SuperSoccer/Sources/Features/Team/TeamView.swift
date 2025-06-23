//
//  TeamView.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct TeamView: View {
    let interactor: any TeamInteractorProtocol
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.large) {
                TeamHeaderView(viewModel: interactor.viewModel.header)
                
                playersSection
                
                Spacer()
            }
            .padding(theme.spacing.large)
        }
        .background(theme.colors.background)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            interactor.eventBus.send(.loadTeamData)
        }
    }
    
    private var playersSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.medium) {
            SSTitle.title3("Players")
            
            LazyVStack(spacing: theme.spacing.small) {
                ForEach(interactor.viewModel.playerRows, id: \.playerId) { playerRowViewModel in
                    PlayerRowView(
                        viewModel: playerRowViewModel,
                        onTap: {
                            interactor.eventBus.send(.playerRowTapped(playerId: playerRowViewModel.playerId))
                        }
                    )
                }
            }
        }
    }
}

#if DEBUG
struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SSThemeProvider {
                TeamView(interactor: MockTeamInteractor())
            }
        }
    }
}
#endif
