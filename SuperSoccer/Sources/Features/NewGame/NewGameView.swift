//
//  NewGameView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

import SwiftUI

struct NewGameViewModel {
    let title: String
    let coachLabelText: String
    let coachFirstNameLabel: String
    var coachFirstName: String
    let coachLastNameLabel: String
    var coachLastName: String
    var teamSelectorModel: TeamSelectorViewModel
    let buttonText: String
    var submitEnabled: Bool
}

struct NewGameView<Interactor: NewGameInteractorProtocol>: View {
    let interactor: Interactor
    
    var body: some View {
        VStack(spacing: 20) {
            Text(interactor.viewModel.coachLabelText)
                .font(.largeTitle)
            TextField(interactor.viewModel.coachFirstNameLabel, text: interactor.bindFirstName())
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            TextField(interactor.viewModel.coachLastNameLabel, text: interactor.bindLastName())
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            Spacer()
            TeamSelectorView(viewModel: interactor.viewModel.teamSelectorModel)
                .padding()
            Spacer()
            Button(interactor.viewModel.buttonText) {
                interactor.eventBus.send(.submitTapped)
            }
            .disabled(!interactor.viewModel.submitEnabled)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.bottom)
        }
        .navigationTitle(interactor.viewModel.title)
    }
}

#if DEBUG
extension NewGameViewModel {
    static func make(
        title: String = "New Game",
        coachLabelText: String = "Coach name",
        coachFirstNameLabel: String = "First name",
        coachFirstName: String = "",
        coachLastNameLabel: String = "Last name",
        coachLastName: String = "",
        teamSelectorModel: TeamSelectorViewModel = .make(),
        buttonText: String = "Start Game",
        submitEnabled: Bool = false
    ) -> Self {
        self.init(
            title: title,
            coachLabelText: coachLabelText,
            coachFirstNameLabel: coachFirstNameLabel,
            coachFirstName: coachFirstName,
            coachLastNameLabel: coachLastNameLabel,
            coachLastName: coachLastName,
            teamSelectorModel: teamSelectorModel,
            buttonText: buttonText,
            submitEnabled: submitEnabled
        )
    }
}
#endif
