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
        
        let teamSelectorTitle: String
        let teamSelectorButtonTitle: String
        
        if let teamInfo = localData.selectedTeamInfo {
            teamSelectorTitle = "\(teamInfo.city) \(teamInfo.teamName)"
            teamSelectorButtonTitle = "Change"
        } else {
            teamSelectorTitle = "Team:"
            teamSelectorButtonTitle = "Select your team"
        }
        
        return NewGameViewModel(
            title: "New game",
            coachLabelText: "Coach",
            coachFirstNameLabel: "First name",
            coachFirstName: localData.coachFirstName,
            coachLastNameLabel: "Last name",
            coachLastName: localData.coachLastName,
            teamSelectorTitle: teamSelectorTitle,
            teamSelectorButtonTitle: teamSelectorButtonTitle,
            buttonText: "Start game",
            submitEnabled: localData.canSubmit
        )
    }
}
