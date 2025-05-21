//
//  SwiftDataManagerFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import SwiftUI
import SwiftData

@MainActor
final class SwiftDataManagerFactory: DataManagerFactory {
    static let shared = SwiftDataManagerFactory()
    
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            SDTeamInfo.self,
            SDTeam.self,
            SDPlayer.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        
    }
    
    func makeDataManager() -> DataManager {
        let storage = SwiftDataStorage(modelContext: sharedModelContainer.mainContext)
        let dataManager = SwiftDataManager(storage: storage)
        
        // Add our initial teams if none exist
        if storage.fetchTeams().isEmpty {
            let auburnInfo = SDTeamInfo(city: "Auburn", teamName: "Tigers")
            let auburnTeam = SDTeam(info: auburnInfo, players: [])
            
            let alabamaInfo = SDTeamInfo(city: "Alabama", teamName: "Crimson Tide Losers")
            let alabamaTeam = SDTeam(info: alabamaInfo, players: [])
            
            dataManager.addNewTeam(auburnTeam)
            dataManager.addNewTeam(alabamaTeam)
        }
        
        return dataManager
    }
}
