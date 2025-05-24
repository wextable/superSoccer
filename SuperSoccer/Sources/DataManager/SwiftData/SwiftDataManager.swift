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
    
    func addNewTeam(_ team: Team) {
        let sdTeam = SDTeam(clientModel: team)
        storage.addTeam(sdTeam)
        swiftDataTeams = storage.fetchTeams()
    }
    
    func deleteTeams(at offsets: IndexSet) {
        for index in offsets {
            storage.deleteTeam(swiftDataTeams[index])
        }
        swiftDataTeams = storage.fetchTeams()
    }
}


