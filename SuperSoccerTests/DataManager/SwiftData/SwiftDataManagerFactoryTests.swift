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
    
    @Test func testMakeSwiftDataManager() async throws {
        // Arrange
        let factory = await SwiftDataManagerFactory.shared
        
        // Act
        let manager = await factory.makeDataManager()
        
        // Assert
        var receivedTeams: [Team] = []
        let cancellable = manager.teamPublisher.sink { teams in
            receivedTeams = teams
        }
        
        #expect(receivedTeams.count == 2)
        
        cancellable.cancel()
    }
}
