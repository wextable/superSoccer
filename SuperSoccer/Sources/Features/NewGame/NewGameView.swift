//
//  NewGameView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

import SwiftUI

struct RetroTextFieldStyle: ViewModifier {
    @Environment(\.ssTheme) private var theme
    
    func body(content: Content) -> some View {
        content
            .font(theme.fonts.body)
            .padding()
            .background(theme.colors.background)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                    .stroke(theme.colors.primaryCyan, lineWidth: 2)
            )
            .foregroundColor(theme.colors.textPrimary)
    }
}

struct RetroTeamSelector: View {
    @Environment(\.ssTheme) private var theme
    
    let title: String
    let buttonTitle: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            SSLabel.headline(title)
            Spacer()
            SSTextButton.make(title: buttonTitle, action: action)
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: theme.cornerRadius.medium)
                .stroke(theme.colors.primaryCyan, lineWidth: 2)
        )
    }
}

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
    
    var body: some View {
        SSThemeProvider {
            ThemedNewGameView(interactor: interactor)
        }
    }
}

private struct ThemedNewGameView: View {
    let interactor: any NewGameInteractorProtocol
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.large) {
                SSTitle.title(interactor.viewModel.coachLabelText)
                
                VStack(spacing: theme.spacing.medium) {
                    TextField(interactor.viewModel.coachFirstNameLabel, text: interactor.bindFirstName())
                        .modifier(RetroTextFieldStyle())
                    
                    TextField(interactor.viewModel.coachLastNameLabel, text: interactor.bindLastName())
                        .modifier(RetroTextFieldStyle())
                }
                
                RetroTeamSelector(
                    title: interactor.viewModel.teamSelectorTitle,
                    buttonTitle: interactor.viewModel.teamSelectorButtonTitle,
                    action: interactor.viewModel.teamSelectorAction
                )
                
                Spacer()
            }
            .padding(theme.spacing.large)
        }
        .safeAreaInset(edge: .bottom) {
            SSPrimaryButton.make(title: interactor.viewModel.buttonText) {
                interactor.eventBus.send(.submitTapped)
            }
            .disabled(!interactor.viewModel.submitEnabled)
            .padding(theme.spacing.large)
        }
        .background(theme.colors.background)
        .navigationTitle(interactor.viewModel.title)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
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
