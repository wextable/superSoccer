//
//  TeamDetailView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import SwiftUI

struct TeamDetailViewModel {
    let title: String
    let teamName: String
}

struct TeamDetailView<Interactor: TeamDetailInteractorProtocol>: View {
    let interactor: Interactor
    
    var body: some View {
        Text(interactor.viewModel.teamName)
            .font(.largeTitle)
            .padding()
            .navigationTitle(interactor.viewModel.title)
    }
}

#if DEBUG
extension TeamDetailViewModel {
    static func make(
        title: String = "Your Team",
        teamName: String = "Auburn Tigers"
    ) -> Self {
        self.init(
            title: title,
            teamName: teamName
        )
    }
}
#endif
