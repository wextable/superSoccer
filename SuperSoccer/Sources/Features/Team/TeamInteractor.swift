//
//  TeamInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import Foundation
import Combine
import Observation

// MARK: - Protocol Separation (following NewGame pattern)

@MainActor
protocol TeamBusinessLogicDelegate: AnyObject {
    func playerRowTapped(_ playerId: String)
}

@MainActor
protocol TeamBusinessLogic: AnyObject {
    var delegate: TeamBusinessLogicDelegate? { get set }
}

@MainActor
protocol TeamInteractorProtocol: TeamBusinessLogic & TeamViewPresenter {}

// MARK: - Implementation

@MainActor
@Observable
final class TeamInteractor: TeamInteractorProtocol {
    var viewModel = TeamViewModel()
    
    private let userTeamId: String
    private let dataManager: DataManagerProtocol
    private let teamViewModelTransform: TeamViewModelTransformProtocol
    weak var delegate: TeamBusinessLogicDelegate?
    
    init(userTeamId: String,
         dataManager: DataManagerProtocol,
         teamViewModelTransform: TeamViewModelTransformProtocol = TeamViewModelTransform()) {
        self.userTeamId = userTeamId
        self.dataManager = dataManager
        self.teamViewModelTransform = teamViewModelTransform
        
        // Load data on initialization
        loadTeamData()
    }
    
    // MARK: - TeamViewPresenter
    
    func loadTeamData() {
        Task { await loadTeamDataAsync() }
    }
    
    func playerRowTapped(_ playerId: String) {
        delegate?.playerRowTapped(playerId)
    }
    
    // MARK: - Private Methods
    
    private func loadTeamDataAsync() async {
        // DataManager handles its own threading - just await the result  
        let (team, coach, players) = await dataManager.getTeamDetails(teamId: userTeamId)
        
        // Use transform to create view model
        self.viewModel = teamViewModelTransform.transform(
            team: team,
            coach: coach,
            players: players
        )
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension TeamInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: TeamInteractor
        
        var dataManager: DataManagerProtocol { target.dataManager }
        var userTeamId: String { target.userTeamId }
    }
}

@MainActor
@Observable
class MockTeamInteractor: TeamInteractorProtocol {
    var viewModel: TeamViewModel
    weak var delegate: TeamBusinessLogicDelegate?
    
    // Test tracking properties
    var loadTeamDataCalled = false
    var playerRowTappedCalled = false
    var lastPlayerRowTappedId: String?
    
    // Callback support for async testing
    var onLoadTeamData: (() -> Void)?
    var onPlayerRowTapped: ((String) -> Void)?
    
    init() {
        self.viewModel = .make()
    }
    
    func loadTeamData() {
        loadTeamDataCalled = true
        onLoadTeamData?()
    }
    
    func playerRowTapped(_ playerId: String) {
        playerRowTappedCalled = true
        lastPlayerRowTappedId = playerId
        onPlayerRowTapped?(playerId)
        delegate?.playerRowTapped(playerId)
    }
}

class MockTeamInteractorDelegate: TeamBusinessLogicDelegate {
    var playerRowTappedCalled = false
    var lastPlayerRowTappedId: String?
    var onPlayerRowTapped: (() -> Void)?
    
    func playerRowTapped(_ playerId: String) {
        playerRowTappedCalled = true
        lastPlayerRowTappedId = playerId
        onPlayerRowTapped?()
    }
}
#endif
