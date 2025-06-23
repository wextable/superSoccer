//
//  TeamInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import Foundation
import Combine

typealias TeamEventBus = PassthroughSubject<TeamEvent, Never>

enum TeamEvent: BusEvent {
    case loadTeamData
    case playerRowTapped(playerId: String)
}

protocol TeamInteractorDelegate: AnyObject {
    func playerRowTapped(_ playerId: String)
}

protocol TeamInteractorProtocol: AnyObject {
    var viewModel: TeamViewModel { get }
    var eventBus: TeamEventBus { get }
}

class TeamInteractor: TeamInteractorProtocol {
    @Published var viewModel: TeamViewModel
    let eventBus = TeamEventBus()
    
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
            header: TeamHeaderViewModel(
                teamName: "",
                teamLogo: "",
                starRating: 0.0,
                leagueStanding: "",
                teamRecord: "",
                coachName: ""
            ),
            playerRows: []
        )
        
        setupSubscriptions()
        loadTeamData()
    }
    
    private func setupSubscriptions() {
        setupEventSubscriptions()
        setupDataSubscriptions()
    }
    
    private func setupEventSubscriptions() {
        eventBus
            .sink { [weak self] event in
                switch event {
                case .loadTeamData:
                    self?.loadTeamData()
                case .playerRowTapped(let playerId):
                    self?.handlePlayerRowTapped(playerId)
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadTeamData() {
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
            PlayerRowViewModel(
                playerId: player.id,
                playerName: "\(player.firstName) \(player.lastName)",
                position: player.position
            )
        }
        
        // Create team header with stats
        let coachFullName = "\(coach.firstName) \(coach.lastName)"
        let header = createTeamHeader(for: team, coachName: coachFullName, allTeams: teams)
        
        viewModel = TeamViewModel(
            coachName: coachFullName,
            teamName: "\(team.info.city) \(team.info.teamName)",
            header: header,
            playerRows: playerRows
        )
    }
    
    private func createTeamHeader(for team: Team, coachName: String, allTeams: [Team]) -> TeamHeaderViewModel {
        // For now, create mock data since we don't have actual stats yet
        // In a real implementation, this would fetch team season stats
        
        // Create team logo from initials
        let cityInitial = String(team.info.city.prefix(1))
        let teamInitial = String(team.info.teamName.prefix(1))
        let teamLogo = cityInitial + teamInitial
        
        // Mock star rating based on team name hash (for consistent but varied ratings)
        let teamNameHash = abs(team.info.teamName.hashValue)
        let starRating = 2.5 + (Double(teamNameHash % 30) / 10.0) // Range: 2.5 - 5.5, then clamped
        let clampedRating = min(5.0, max(1.0, starRating))
        
        // Mock league standing (could be calculated from actual season stats)
        let standings = ["1st Place", "2nd Place", "3rd Place", "4th Place", "5th Place", "6th Place"]
        let standingIndex = teamNameHash % standings.count
        let leagueStanding = standings[standingIndex]
        
        // Mock team record
        let wins = 10 + (teamNameHash % 20)
        let losses = 2 + (teamNameHash % 8)
        let draws = 1 + (teamNameHash % 6)
        let teamRecord = "\(wins)W-\(losses)L-\(draws)D"
        
        return TeamHeaderViewModel(
            teamName: "\(team.info.city) \(team.info.teamName)",
            teamLogo: teamLogo,
            starRating: clampedRating,
            leagueStanding: leagueStanding,
            teamRecord: teamRecord,
            coachName: coachName
        )
    }
    
    private func handlePlayerRowTapped(_ playerId: String) {
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
    let eventBus = TeamEventBus()
    
    init() {
        self.viewModel = .make()
    }
}

class MockTeamInteractorDelegate: TeamInteractorDelegate {
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
