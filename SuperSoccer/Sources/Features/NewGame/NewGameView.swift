//
//  NewGameView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

import SwiftUI

struct NewGameViewModel {
    var title: String = "New game"
    var coachLabelText: String = "Coach"
    var coachFirstNameLabel: String = "First name"
    var coachFirstName: String = ""
    var coachLastNameLabel: String = "Last name"
    var coachLastName: String = ""
    var teamSelectorTitle: String = "Team:"
    var teamSelectorButtonTitle: String = "Select your team"
    var teamSelectorAction: () -> Void = {}
    var buttonText: String = "Start game"
    var submitEnabled: Bool = false
}

struct NewGameView: View {
    let interactor: any NewGameInteractorProtocol
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        ScrollView {
            formContent
        }
        .safeAreaInset(edge: .bottom) {
            submitButton
        }
        .background(theme.colors.background)
        .navigationTitle(interactor.viewModel.title)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    private var formContent: some View {
        VStack(alignment: .leading, spacing: theme.spacing.large) {
            SSTitle.title(interactor.viewModel.coachLabelText)
            
            coachNameFields
            
            TeamSelectorView(
                title: interactor.viewModel.teamSelectorTitle,
                buttonTitle: interactor.viewModel.teamSelectorButtonTitle,
                action: interactor.viewModel.teamSelectorAction
            )
            
            Spacer()
        }
        .padding(theme.spacing.large)
    }
    
    private var coachNameFields: some View {
        VStack(spacing: theme.spacing.medium) {
            TextField(interactor.viewModel.coachFirstNameLabel, text: interactor.bindFirstName())
                .textFieldStyle(SSTextFieldStyle())
            
            TextField(interactor.viewModel.coachLastNameLabel, text: interactor.bindLastName())
                .textFieldStyle(SSTextFieldStyle())
        }
    }
    
    private var submitButton: some View {
        SSPrimaryButton.make(title: interactor.viewModel.buttonText) {
            interactor.eventBus.send(.submitTapped)
        }
        .disabled(!interactor.viewModel.submitEnabled)
        .padding(theme.spacing.large)
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
        teamSelectorTitle: String = "Team:",
        teamSelectorButtonTitle: String = "Select your team",
        teamSelectorAction: @escaping () -> Void = {},
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
            teamSelectorTitle: teamSelectorTitle,
            teamSelectorButtonTitle: teamSelectorButtonTitle,
            teamSelectorAction: teamSelectorAction,
            buttonText: buttonText,
            submitEnabled: submitEnabled
        )
    }
}
#endif
