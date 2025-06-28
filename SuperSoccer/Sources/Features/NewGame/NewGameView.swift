//
//  NewGameView.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

import SwiftUI

protocol NewGameViewPresenter: AnyObject {
    var viewModel: NewGameViewModel { get }
    func bindFirstName() -> Binding<String>
    func bindLastName() -> Binding<String>
    func submitTapped()
    func teamSelectorTapped()
}

struct NewGameViewModel {
    var title: String = "New game"
    var coachLabelText: String = "Coach"
    var coachFirstNameLabel: String = "First name"
    var coachFirstName: String = ""
    var coachLastNameLabel: String = "Last name"
    var coachLastName: String = ""    
    var teamSelectorModel: TeamSelectorViewModel = TeamSelectorViewModel()
    var buttonText: String = "Start game"
    var submitEnabled: Bool = false
}

struct NewGameView: View {
    let presenter: NewGameViewPresenter
    @Environment(\.ssTheme) private var theme
    
    var body: some View {
        ScrollView {
            formContent
        }
        .safeAreaInset(edge: .bottom) {
            submitButton
        }
        .background(theme.colors.background)
        .navigationTitle(presenter.viewModel.title)
        .toolbarBackground(theme.colors.background, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
    
    private var formContent: some View {
        VStack(alignment: .leading, spacing: theme.spacing.large) {
            SSTitle.title(presenter.viewModel.coachLabelText)
            
            coachNameFields
            
            TeamSelectorView(
                viewModel: presenter.viewModel.teamSelectorModel,
                action: { presenter.teamSelectorTapped() }
            )
            
            Spacer()
        }
        .padding(theme.spacing.large)
    }
    
    private var coachNameFields: some View {
        VStack(spacing: theme.spacing.medium) {
            TextField(presenter.viewModel.coachFirstNameLabel, text: presenter.bindFirstName())
                .textFieldStyle(SSTextFieldStyle())
            
            TextField(presenter.viewModel.coachLastNameLabel, text: presenter.bindLastName())
                .textFieldStyle(SSTextFieldStyle())
        }
    }
    
    private var submitButton: some View {
        SSPrimaryButton.make(title: presenter.viewModel.buttonText) {
            presenter.submitTapped()
        }
        .disabled(!presenter.viewModel.submitEnabled)
        .padding(theme.spacing.large)
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension NewGameViewModel {
    static func make(
        title: String = "New game",
        coachLabelText: String = "Coach name",
        coachFirstNameLabel: String = "First name",
        coachFirstName: String = "",
        coachLastNameLabel: String = "Last name",
        coachLastName: String = "",
        teamSelectorModel: TeamSelectorViewModel = TeamSelectorViewModel.make(),
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
