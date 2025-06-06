//
//  SwiftDataManager.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Combine
import Foundation

final class SwiftDataManager: DataManagerProtocol {
    private let storage: SwiftDataStorageProtocol
    private let clientToSDTransformer: ClientToSwiftDataTransformer
    private let sdToClientTransformer: SwiftDataToClientTransformer
    
    // Reactive Publishers
    @Published private var careersSubject: [Career] = []
    @Published private var leaguesSubject: [League] = []
    @Published private var teamsSubject: [Team] = []
    @Published private var playersSubject: [Player] = []
    @Published private var coachesSubject: [Coach] = []
    
    lazy var careerPublisher: AnyPublisher<[Career], Never> = $careersSubject.eraseToAnyPublisher()
    lazy var leaguePublisher: AnyPublisher<[League], Never> = $leaguesSubject.eraseToAnyPublisher()
    lazy var teamPublisher: AnyPublisher<[Team], Never> = $teamsSubject.eraseToAnyPublisher()
    lazy var playerPublisher: AnyPublisher<[Player], Never> = $playersSubject.eraseToAnyPublisher()
    lazy var coachPublisher: AnyPublisher<[Coach], Never> = $coachesSubject.eraseToAnyPublisher()
    
    init(
        storage: SwiftDataStorageProtocol,
        clientToSDTransformer: ClientToSwiftDataTransformer = ClientToSwiftDataTransformer(),
        sdToClientTransformer: SwiftDataToClientTransformer = SwiftDataToClientTransformer()
    ) {
        self.storage = storage
        self.clientToSDTransformer = clientToSDTransformer
        self.sdToClientTransformer = sdToClientTransformer
        
        // Initialize publishers with current data
        refreshPublishers()
    }
    
    // MARK: - Career Management
    
    func createNewCareer(_ request: CreateNewCareerRequest) async throws -> CreateNewCareerResult {
        // 1. Transform request to SwiftData entities
        let bundle = clientToSDTransformer.createCareerEntities(from: request)
        
        // 2. Save to storage using the complex operation
        let savedCareer = try storage.createCareerBundle(bundle)
        
        // 3. Update reactive publishers
        refreshPublishers()
        
        // 4. Return result
        return CreateNewCareerResult(
            careerId: savedCareer.id,
            coachId: bundle.coach.id,
            userTeamId: bundle.teams.first { $0.id == request.selectedTeamId }?.id ?? bundle.teams.first!.id,
            leagueId: bundle.league.id,
            currentSeasonId: bundle.season.id,
            allTeamIds: bundle.teams.map { $0.id },
            allPlayerIds: bundle.players.map { $0.id }
        )
    }
    
    func fetchCareers() -> [Career] {
        let sdCareers = storage.fetchCareers()
        return sdCareers.map { sdToClientTransformer.transform($0) }
    }
    
    // MARK: - League Management
    
    func fetchLeagues() -> [League] {
        let sdLeagues = storage.fetchLeagues()
        return sdLeagues.map { sdToClientTransformer.transform($0) }
    }
    
    // MARK: - Team Management
    
    func fetchTeams() -> [Team] {
        let sdTeams = storage.fetchTeams()
        return sdTeams.map { sdToClientTransformer.transform($0) }
    }
    
    // MARK: - Player Management
    
    func fetchPlayers() -> [Player] {
        let sdPlayers = storage.fetchPlayers()
        return sdPlayers.map { sdToClientTransformer.transform($0) }
    }
    
    // MARK: - Coach Management
    
    func fetchCoaches() -> [Coach] {
        let sdCoaches = storage.fetchCoaches()
        return sdCoaches.map { sdToClientTransformer.transform($0) }
    }
    
    // MARK: - Private Methods
    
    private func refreshPublishers() {
        careersSubject = fetchCareers()
        leaguesSubject = fetchLeagues()
        teamsSubject = fetchTeams()
        playersSubject = fetchPlayers()
        coachesSubject = fetchCoaches()
    }
}

#if DEBUG
extension SwiftDataManager {
    struct Data {
        let coaches: [Coach]
    }
}
#endif
