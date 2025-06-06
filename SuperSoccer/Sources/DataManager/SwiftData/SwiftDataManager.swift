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
        
    @Published private var teamsSubject: [Team] = []
    lazy var teamPublisher: AnyPublisher<[Team], Never> = $teamsSubject.eraseToAnyPublisher()
    private var swiftDataTeams: [SDTeam] = [] {
        didSet {
            teamsSubject = swiftDataTeams.map {
                Team(sdTeam: $0)
            }
        }
    }
    
    init(storage: SwiftDataStorageProtocol) {
        self.storage = storage
        swiftDataTeams = storage.fetchTeams()
        teamsSubject = swiftDataTeams.map {
            Team(sdTeam: $0)
        }
    }
    
    func teamInfos() -> [TeamInfo] {
        let sdTeamInfos = storage.fetchTeamInfos()
        return sdTeamInfos.map { TeamInfo(sdTeamInfo: $0) }
    }
    
    func addCoach(_ coach: Coach) {
//        let sdCoach = SDCoach(clientModel: coach)
//        storage.addCoach(sdCoach)
//        swiftDataTeams = storage.fetchTeams()
    }
    
    func addNewTeam(_ team: Team) {
//        let sdTeam = SDTeam(clientModel: team)
//        storage.addTeam(sdTeam)
//        swiftDataTeams = storage.fetchTeams()
    }
    
    func deleteTeams(at offsets: IndexSet) {
        for index in offsets {
            storage.deleteTeam(swiftDataTeams[index])
        }
        swiftDataTeams = storage.fetchTeams()
    }
}

extension SwiftDataManager {
    struct Data {
        let coaches: [Coach]
    }
}
