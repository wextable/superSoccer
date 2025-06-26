//
//  NewGameViewModelTransform.swift
//  SuperSoccer
//
//  Created by Wesley on 6/26/25.
//

protocol NewGameViewModelTransformProtocol {
    func transform(localData: NewGameLocalDataSource.Data) -> NewGameViewModel
}

final class NewGameViewModelTransform: NewGameViewModelTransformProtocol {
    func transform(localData: NewGameLocalDataSource.Data) -> NewGameViewModel {
        let teamSelectorModel = transform(teamInfo: localData.selectedTeamInfo)
        
        return NewGameViewModel(
            title: "New game",
            coachLabelText: "Coach",
            coachFirstNameLabel: "First name",
            coachFirstName: localData.coachFirstName,
            coachLastNameLabel: "Last name",
            coachLastName: localData.coachLastName,
            teamSelectorModel: teamSelectorModel,
            buttonText: "Start game",
            submitEnabled: localData.canSubmit
        )
    }
    
    private func transform(teamInfo: TeamInfo?) -> TeamSelectorViewModel {
        let teamSelectorTitle: String
        let teamSelectorButtonTitle: String
        if let teamInfo = teamInfo {
            teamSelectorTitle = "\(teamInfo.city) \(teamInfo.teamName)"
            teamSelectorButtonTitle = "Change"
        } else {
            teamSelectorTitle = "Team:"
            teamSelectorButtonTitle = "Select your team"
        }
        return TeamSelectorViewModel(
            title: teamSelectorTitle,
            buttonTitle: teamSelectorButtonTitle
        )
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
final class MockNewGameViewModelTransform: NewGameViewModelTransformProtocol {
    var didCallTransform = false
    var mockViewModel: NewGameViewModel = NewGameViewModel.make()
    
    func transform(localData: NewGameLocalDataSource.Data) -> NewGameViewModel {
        didCallTransform = true
        return mockViewModel
    }
}
#endif
