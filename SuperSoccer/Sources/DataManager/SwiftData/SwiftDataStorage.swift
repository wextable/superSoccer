//
//  SwiftDataStorage.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Foundation
import SwiftData

protocol SwiftDataStorageProtocol {
    func fetchTeamInfos() -> [SDTeamInfo]
    func fetchTeams() -> [SDTeam]
    func addTeam(_ team: SDTeam)
    func deleteTeam(_ team: SDTeam)
    func addCoach(_ coach: SDCoach)
}

class SwiftDataStorage: SwiftDataStorageProtocol {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        populateStaticData()
    }
    
    private func populateStaticData() {
        // Add our initial teams if none exist
        if fetchTeamInfos().isEmpty {
            let auburnInfo = SDTeamInfo(city: "Auburn", teamName: "Tigers")
            let alabamaInfo = SDTeamInfo(city: "Alabama", teamName: "Crimson Tide Losers")
            
            addTeamInfo(auburnInfo)
            addTeamInfo(alabamaInfo)
        }
    }
   
    func fetchTeamInfos() -> [SDTeamInfo] {
        let descriptor = FetchDescriptor<SDTeamInfo>(
            sortBy: [SortDescriptor(\.city)]
        )
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    
    func addTeamInfo(_ teamInfo: SDTeamInfo) {
        modelContext.insert(teamInfo)
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
    
    func addCoach(_ coach: SDCoach) {
        modelContext.insert(coach)
    }
}

#if DEBUG
class MockSwiftDataStorage: SwiftDataStorageProtocol {
    
    var mockCoach: SDCoach?
    var mockTeams: [SDTeam] = []

    func addCoach(_ coach: SDCoach) {
        mockCoach = coach
    }
    
    func fetchTeamInfos() -> [SDTeamInfo] {
        return mockTeams.map { $0.info }
    }
    
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
