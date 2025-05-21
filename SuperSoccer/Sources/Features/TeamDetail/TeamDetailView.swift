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
            .navigationBarTitle(interactor.viewModel.title, displayMode: .inline)
        .navigationTitle(interactor.viewModel.title + "???")
    }
}

//#Preview {
//    let clientModels = [TeamInfoClientModel.make()]
//    let interactor = TeamSelectInteractor(clientModels: clientModels)
//    TeamDetailView(interactor: interactor)
//}
