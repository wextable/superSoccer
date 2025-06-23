//
//  PlayerRowView.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct PlayerRowViewModel: Identifiable, Hashable {
    var id: String { playerId }
    let playerId: String
    let playerName: String
    let position: String
}

struct PlayerRowView: View {
    @Environment(\.ssTheme) private var theme
    
    let viewModel: PlayerRowViewModel
    let onTap: () -> Void
    
    var body: some View {
        HStack(spacing: theme.spacing.medium) {
            // Position badge
            positionBadge
            
            // Player info
            VStack(alignment: .leading, spacing: theme.spacing.extraSmall) {
                SSTitle.title3(viewModel.playerName)
                    .fontWeight(.semibold)
                
                SSLabel.caption("Position")
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            Spacer()
            
            // Chevron indicator
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(theme.colors.textSecondary)
        }
        .padding(theme.spacing.medium)
        .background(theme.colors.background)
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                .stroke(theme.colors.primaryCyan.opacity(0.3), lineWidth: 1)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
    
    private var positionBadge: some View {
        ZStack {
            Circle()
                .fill(theme.colors.primaryCyan)
                .frame(width: 40, height: 40)
            
            SSLabel.caption(viewModel.position)
                .fontWeight(.bold)
                .foregroundColor(theme.colors.background)
        }
    }
}

#if DEBUG
extension PlayerRowViewModel {
    static func make(
        playerId: String = "mock-player-id",
        playerName: String = "Mock Player",
        position: String = "ST"
    ) -> PlayerRowViewModel {
        PlayerRowViewModel(
            playerId: playerId,
            playerName: playerName,
            position: position
        )
    }
}

struct PlayerRowView_Previews: PreviewProvider {
    static var previews: some View {
        SSThemeProvider {
            VStack(spacing: 12) {
                PlayerRowView(
                    viewModel: .make(
                        playerName: "Cristiano Ronaldo",
                        position: "ST"
                    ),
                    onTap: {}
                )
                
                PlayerRowView(
                    viewModel: .make(
                        playerName: "Lionel Messi",
                        position: "RW"
                    ),
                    onTap: {}
                )
                
                PlayerRowView(
                    viewModel: .make(
                        playerName: "Virgil van Dijk",
                        position: "CB"
                    ),
                    onTap: {}
                )
            }
            .padding()
            .background(Color.gray.opacity(0.1))
        }
    }
}
#endif
