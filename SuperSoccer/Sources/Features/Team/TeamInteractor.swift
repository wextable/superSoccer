//
//  TeamInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import Foundation
import Combine

protocol TeamInteractorDelegate: AnyObject {
    func playerRowTapped(_ playerId: String)
}

protocol TeamInteractorProtocol: AnyObject {
    var viewModel: TeamViewModel { get }
    func loadTeamData()
}

class TeamInteractor: TeamInteractorProtocol {
    @Published var viewModel: TeamViewModel
    
    private let userTeamId: String
    private let dataManager: DataManagerProtocol
    private weak var delegate: TeamInteractorDelegate?
    private var cancellables = Set<AnyCancellable>()
    
    init(userTeamId: String,
         dataManager: DataManagerProtocol,
         delegate: TeamInteractorDelegate) {
        self.userTeamId = userTeamId
        self.dataManager = dataManager
        self.delegate = delegate
        
        self.viewModel = TeamViewModel(
            coachName: "",
            teamName: "",
            playerRows: []
        )
        
        setupDataSubscriptions()
        loadTeamData()
    }
    
    func loadTeamData() {
        // Load team, coach, and player data
        let teams = dataManager.fetchTeams()
        let coaches = dataManager.fetchCoaches()
        let players = dataManager.fetchPlayers()
        
        guard let team = teams.first(where: { $0.id == userTeamId }),
              let coach = coaches.first(where: { $0.id == team.coachId }) else {
            return
        }
        
        let teamPlayers = players.filter { team.playerIds.contains($0.id) }
        let playerRows = teamPlayers.map { player in
            PlayerRowView.PlayerRowViewModel(
                id: player.id,
                playerId: player.id,
                playerName: "\(player.firstName) \(player.lastName)",
                position: player.position
            )
        }
        
        viewModel = TeamViewModel(
            coachName: "\(coach.firstName) \(coach.lastName)",
            teamName: "\(team.info.city) \(team.info.teamName)",
            playerRows: playerRows
        )
    }
    
    func playerRowTapped(_ playerId: String) {
        delegate?.playerRowTapped(playerId)
    }
    
    private func setupDataSubscriptions() {
        // Subscribe to data changes for reactive updates
        dataManager.teamPublisher
            .combineLatest(dataManager.coachPublisher, dataManager.playerPublisher)
            .sink { [weak self] _, _, _ in
                self?.loadTeamData()
            }
            .store(in: &cancellables)
    }
}

#if DEBUG
class MockTeamInteractor: TeamInteractorProtocol {
    @Published var viewModel: TeamViewModel
    
    init() {
        self.viewModel = TeamViewModel(
            coachName: "Mock Coach",
            teamName: "Mock Team",
            playerRows: [
                PlayerRowView.PlayerRowViewModel(
                    id: "1",
                    playerId: "1",
                    playerName: "Mock Player",
                    position: "Forward"
                )
            ]
        )
    }
    
    func loadTeamData() {
        // Mock implementation
    }
}
#endif
