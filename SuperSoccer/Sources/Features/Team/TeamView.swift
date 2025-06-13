//
//  TeamView.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct TeamView: View {
    let interactor: any TeamInteractorProtocol
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Coach Section
            VStack(alignment: .leading) {
                Text("Coach")
                    .font(.headline)
                Text(interactor.viewModel.coachName)
                    .font(.title2)
            }
            
            // Team Section
            VStack(alignment: .leading) {
                Text("Team")
                    .font(.headline)
                Text(interactor.viewModel.teamName)
                    .font(.title2)
            }
            
            // Players Section
            VStack(alignment: .leading) {
                Text("Players")
                    .font(.headline)
                
                LazyVStack {
                    ForEach(interactor.viewModel.playerRows, id: \.id) { playerRowViewModel in
                        PlayerRowView(
                            viewModel: playerRowViewModel,
                            onTap: {
                            //    interactor.playerRowTapped(playerRowViewModel.playerId)
                            }
                        )
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("My Team")
        .onAppear {
            interactor.loadTeamData()
        }
    }
    
    static func make(interactor: any TeamInteractorProtocol) -> TeamView {
        return TeamView(interactor: interactor)
    }
}
