//
//  PlayerRowView.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct PlayerRowView: View {
    let viewModel: PlayerRowViewModel
    let onTap: () -> Void
    
    struct PlayerRowViewModel: Identifiable, Hashable {
        let id: String
        let playerId: String
        let playerName: String
        let position: String
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(viewModel.playerName)
                    .font(.headline)
                Text(viewModel.position)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .onTapGesture {
            onTap()
        }
    }
}
