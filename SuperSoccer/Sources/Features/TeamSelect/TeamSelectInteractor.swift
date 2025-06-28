//
//  TeamSelectInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 5/15/25.
//

import Combine
import Observation

protocol TeamSelectInteractorDelegate: AnyObject {
    func interactorDidSelectTeam(_ team: TeamInfo)
    func interactorDidCancel()
}

protocol TeamSelectBusinessLogic: AnyObject {
    var delegate: TeamSelectInteractorDelegate? { get set }
}

protocol TeamSelectInteractorProtocol: TeamSelectBusinessLogic & TeamSelectViewPresenter {}

@Observable
final class TeamSelectInteractor: TeamSelectInteractorProtocol {
    private let dataManager: DataManagerProtocol
    weak var delegate: TeamSelectInteractorDelegate?
    
    private let teamInfos: [TeamInfo]
    var viewModel: TeamSelectViewModel
    
    init(dataManager: DataManagerProtocol) {
        self.dataManager = dataManager
        
        teamInfos = dataManager.fetchTeamInfos()
        let teamModels = teamInfos.map {
            TeamThumbnailViewModel(
                id: $0.id,
                text: "\($0.city) \($0.teamName)"
            )
        }
        viewModel = TeamSelectViewModel(
            title: "Select a team",
            teamModels: teamModels
        )
    }
    
    func teamSelected(teamInfoId: String) {
        guard let teamInfo = teamInfos.first(where: { $0.id == teamInfoId }) else { return }
        delegate?.interactorDidSelectTeam(teamInfo)
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamSelectInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: TeamSelectInteractor
        
        var dataManager: DataManagerProtocol { target.dataManager }
    }
}

class MockTeamSelectInteractor: TeamSelectInteractorProtocol {
    var mockTeamModels: [TeamThumbnailViewModel] = [
        TeamThumbnailViewModel.make(id: "1", text: "Team A"),
        TeamThumbnailViewModel.make(id: "2", text: "Team B"),
        TeamThumbnailViewModel.make(id: "3", text: "Team C")
    ]
    var viewModel: TeamSelectViewModel {
        TeamSelectViewModel(
            title: "Select a team",
            teamModels: mockTeamModels
        )
    }
    weak var delegate: TeamSelectInteractorDelegate?
    
    // Test tracking properties
    var teamSelectedCalled = false
    var lastSelectedTeamId: String?
    
    // Callback support for async testing
    var onTeamSelected: ((String) -> Void)?
    
    func teamSelected(teamInfoId: String) {
        teamSelectedCalled = true
        lastSelectedTeamId = teamInfoId
        onTeamSelected?(teamInfoId)
    }
}

class MockTeamSelectInteractorDelegate: TeamSelectInteractorDelegate {    
    var didSelectTeam = false
    var selectedTeam: TeamInfo?
    var onDidSelectTeam: (() -> Void)?
    func interactorDidSelectTeam(_ team: TeamInfo) {
        didSelectTeam = true
        selectedTeam = team
        onDidSelectTeam?()
    }
    
    var didCancel = false
    var onDidCancel: (() -> Void)?
    func interactorDidCancel() {
        didCancel = true
        onDidCancel?()
    }
}
#endif
