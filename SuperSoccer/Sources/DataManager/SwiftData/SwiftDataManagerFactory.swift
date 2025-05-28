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
        SDTeamInfo.self,
        SDCoach.self,
        SDPlayer.self,
        SDTeam.self
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
