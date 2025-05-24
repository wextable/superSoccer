//
//  SwiftDataStorage.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Foundation
import SwiftData

protocol SwiftDataStorageProtocol {
    func fetchTeams() -> [SDTeam]
    func addTeam(_ team: SDTeam)
    func deleteTeam(_ team: SDTeam)
}

class SwiftDataStorage: SwiftDataStorageProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        populateStaticData()
    }
    
    private func populateStaticData() {
        // Add our initial teams if none exist
        if fetchTeams().isEmpty {
            let auburnInfo = SDTeamInfo(city: "Auburn", teamName: "Tigers")
            let auburnTeam = SDTeam(info: auburnInfo, players: [])
            
            let alabamaInfo = SDTeamInfo(city: "Alabama", teamName: "Crimson Tide Losers")
            let alabamaTeam = SDTeam(info: alabamaInfo, players: [])
            
            addTeam(auburnTeam)
            addTeam(alabamaTeam)
        }
    }
    
    func fetchTeams() -> [SDTeam] {
        let descriptor = FetchDescriptor<SDTeam>(
            sortBy: [SortDescriptor(\.info.city)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addTeam(_ team: SDTeam) {
        modelContext.insert(team)
    }
    
    func deleteTeam(_ team: SDTeam) {
        modelContext.delete(team)
    }
}

#if DEBUG
class MockSwiftDataStorage: SwiftDataStorageProtocol {
    var mockTeams: [SDTeam] = []

    func fetchTeams() -> [SDTeam] {
        return mockTeams
    }

    func addTeam(_ team: SDTeam) {
        mockTeams.append(team)
    }
    
    func deleteTeam(_ team: SDTeam) {
        mockTeams.removeAll(where: { $0.id == team.id })
    }
}
#endif
