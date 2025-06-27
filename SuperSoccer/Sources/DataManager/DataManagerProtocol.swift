//
//  DataManagerProtocol.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Combine
import Foundation

protocol DataManagerProtocol: Sendable {
    // Career Management
    func createNewCareer(_ request: CreateNewCareerRequest) async throws -> CreateNewCareerResult
    func fetchCareers() -> [Career]
    var careerPublisher: AnyPublisher<[Career], Never> { get }
    
    // League Management
    func fetchLeagues() -> [League]
    var leaguePublisher: AnyPublisher<[League], Never> { get }
    
    // Team Management
    func fetchTeamInfos() -> [TeamInfo]
    func fetchTeams() -> [Team]
    var teamPublisher: AnyPublisher<[Team], Never> { get }
    
    // NEW: Use-case method for team details
    @MainActor
    func getTeamDetails(teamId: String) async -> (team: Team?, coach: Coach?, players: [Player])
    
    // Player Management
    func fetchPlayers() -> [Player]
    var playerPublisher: AnyPublisher<[Player], Never> { get }
    
    // Coach Management
    func fetchCoaches() -> [Coach]
    var coachPublisher: AnyPublisher<[Coach], Never> { get }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
class MockDataManager: DataManagerProtocol {
    @Published var mockCareers: [Career] = []
    @Published var mockLeagues: [League] = []
    var mockTeamInfos: [TeamInfo] = []
    @Published var mockTeams: [Team] = []
    @Published var mockPlayers: [Player] = []
    @Published var mockCoaches: [Coach] = []
    
    lazy var careerPublisher: AnyPublisher<[Career], Never> = $mockCareers.eraseToAnyPublisher()
    lazy var leaguePublisher: AnyPublisher<[League], Never> = $mockLeagues.eraseToAnyPublisher()
    lazy var teamPublisher: AnyPublisher<[Team], Never> = $mockTeams.eraseToAnyPublisher()
    lazy var playerPublisher: AnyPublisher<[Player], Never> = $mockPlayers.eraseToAnyPublisher()
    lazy var coachPublisher: AnyPublisher<[Coach], Never> = $mockCoaches.eraseToAnyPublisher()
    
    var createNewCareerCalled = false
    var lastCreateNewCareerRequest: CreateNewCareerRequest?
    var mockCreateNewCareerResult = CreateNewCareerResult(
        careerId: "mock-career-id",
        coachId: "mock-coach-id",
        userTeamId: "mock-user-team-id",
        leagueId: "mock-league-id",
        currentSeasonId: "mock-season-id",
        allTeamIds: ["mock-team-1", "mock-team-2"],
        allPlayerIds: ["mock-player-1", "mock-player-2"]
    )
    func createNewCareer(_ request: CreateNewCareerRequest) async throws -> CreateNewCareerResult {
        createNewCareerCalled = true
        lastCreateNewCareerRequest = request        
        return mockCreateNewCareerResult
    }
    
    var fetchCareersCalled = false
    var fetchLeaguesCalled = false
    var fetchTeamInfosCalled = false
    var fetchTeamsCalled = false
    var fetchPlayersCalled = false
    var fetchCoachesCalled = false
    
    func fetchCareers() -> [Career] {
        fetchCareersCalled = true
        return mockCareers
    }
    func fetchLeagues() -> [League] {
        fetchLeaguesCalled = true
        return mockLeagues
    }
    func fetchTeamInfos() -> [TeamInfo] {
        fetchTeamInfosCalled = true
        return mockTeamInfos
    }
    func fetchTeams() -> [Team] {
        fetchTeamsCalled = true
        return mockTeams
    }
    func fetchPlayers() -> [Player] {
        fetchPlayersCalled = true
        return mockPlayers
    }
    func fetchCoaches() -> [Coach] {
        fetchCoachesCalled = true
        return mockCoaches
    }
    
    var getTeamDetailsCalled = false
    var lastGetTeamDetailsId: String?
    
    @MainActor
    func getTeamDetails(teamId: String) async -> (team: Team?, coach: Coach?, players: [Player]) {
        getTeamDetailsCalled = true
        lastGetTeamDetailsId = teamId
        
        let team = mockTeams.first { $0.id == teamId }
        let coach = team.flatMap { t in mockCoaches.first { $0.id == t.coachId } }
        let players = team?.playerIds.compactMap { playerId in
            mockPlayers.first { $0.id == playerId }
        } ?? []
        
        return (team: team, coach: coach, players: players)
    }
}
#endif
