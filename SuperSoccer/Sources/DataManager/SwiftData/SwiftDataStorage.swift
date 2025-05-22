//
//  SwiftDataStorage.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//
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
    }
    
    func fetchTeams() -> [SDTeam] {
        // Using try? for simplicity here
        return (try? modelContext.fetch(FetchDescriptor<SDTeam>())) ?? []
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
