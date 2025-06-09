//
//  SwiftDataManagerFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import SwiftUI
import SwiftData

@MainActor
final class SwiftDataManagerFactory: DataManagerFactoryProtocol {
    static let shared = SwiftDataManagerFactory()
    
    static let schema = Schema([
        SDCareer.self,
        SDCoach.self,
        SDContract.self,
        SDLeague.self,
        SDMatch.self,
        SDPlayer.self,
        SDPlayerCareerStats.self,
        SDPlayerMatchStats.self,
        SDPlayerSeasonStats.self,
        SDSeason.self,
        SDTeam.self,
        SDTeamCareerStats.self,
        SDTeamInfo.self,
        SDTeamMatchStats.self,
        SDTeamSeasonStats.self
    ])
    
    private let sharedModelContainer: ModelContainer = {
        let schema = SwiftDataManagerFactory.schema
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    init() {
        
    }
    
    func makeDataManager() -> DataManagerProtocol {
        let storage = SwiftDataStorage(modelContext: sharedModelContainer.mainContext)
        let dataManager = SwiftDataManager(storage: storage)
        
        return dataManager
    }
}

#if DEBUG
extension SwiftDataManagerFactory {
    static var mockModelContainer: ModelContainer {
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
#endif
