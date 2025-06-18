//
//  SwiftDataManagerFactoryTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Testing
import SwiftData
@testable import SuperSoccer

struct SwiftDataManagerFactoryTests {
    
    @Test("Factory should create a SwiftDataManager instance")
    func testFactoryCreatesManager() async throws {
        // Arrange
        let factory = await SwiftDataManagerFactory()
        
        // Act
        let manager = await factory.makeDataManager()
        
        // Assert
        #expect(manager is SwiftDataManager)
    }
    
    @Test("TeamInfos should be available in the created manager")
    func testCreatedManagerInitialState() async throws {
        // Arrange
        let factory = await SwiftDataManagerFactory()
        
        // Act
        let manager = await factory.makeDataManager()
        
        // Assert
        #expect(!manager.fetchTeamInfos().isEmpty)
    }
    
    @Test("Created manager should be able to perform operations")
    func testCreatedManagerOperations() async throws {
        // Arrange
        let factory = await SwiftDataManagerFactory()
        let manager = await factory.makeDataManager()
        
        // Act
        let request = CreateNewCareerRequest(
            coachFirstName: "Hugh",
            coachLastName: "Freeze",
            selectedTeamInfoId: manager.fetchTeamInfos()[0].id,
            leagueName: "English Premier League",
            seasonYear: 2025
        )
        let result = try await manager.createNewCareer(request)
        
        // Assert
        #expect(!manager.fetchCareers().isEmpty)
        #expect(!manager.fetchLeagues().isEmpty)
        #expect(!manager.fetchTeams().isEmpty)
        #expect(!manager.fetchPlayers().isEmpty)
        #expect(!manager.fetchCoaches().isEmpty)
        #expect(result.coachId != "")
        #expect(result.careerId != "")
    }
}
