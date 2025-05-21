//
//  SwiftDataManager.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Combine
import Foundation

final class SwiftDataManager: DataManager {
    private let storage: SwiftDataStorageProtocol
        
    @Published private var teamsSubject: [TeamClientModel] = []
    lazy var teamPublisher: AnyPublisher<[TeamClientModel], Never> = $teamsSubject.eraseToAnyPublisher()
    private var swiftDataTeams: [SDTeam] = [] {
        didSet {
            teamsSubject = swiftDataTeams.map {
                TeamClientModel(sdTeam: $0)
            }
        }
    }
    
    init(storage: SwiftDataStorageProtocol) {
        self.storage = storage
        swiftDataTeams = storage.fetchTeams()
        teamsSubject = swiftDataTeams.map {
            TeamClientModel(sdTeam: $0)
        }
    }
    
    func addNewTeam() {
        let team = SDTeam()
        storage.addTeam(team)
        swiftDataTeams = storage.fetchTeams()
    }
    
    func addNewTeam(_ team: SDTeam) {
        storage.addTeam(team)
        swiftDataTeams = storage.fetchTeams()
    }
    
    func deleteTeams(at offsets: IndexSet) {
        for index in offsets {
            storage.deleteTeam(swiftDataTeams[index])
        }
        swiftDataTeams = storage.fetchTeams()
    }
}
