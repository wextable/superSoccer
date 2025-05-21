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
