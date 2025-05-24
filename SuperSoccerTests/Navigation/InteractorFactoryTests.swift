//
//  InteractorFactoryTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Testing
@testable import SuperSoccer

struct InteractorFactoryTests {
    @Test func testMakeTeamSelectInteractor() async throws {
        // Arrange
        let dependencies = MockDependencyContainer()
        let factory = InteractorFactory(dependencies: dependencies)
        
        // Act
        let interactor = factory.makeTeamSelectInteractor()
        
        // Assert
        guard let teamSelectInteractor = interactor as? TeamSelectInteractor else {
            Issue.record("Expected TeamSelectInteractor instance")
            return
        }
        
        // Verify dependencies were passed correctly
        #expect(teamSelectInteractor.testHooks.navigationCoordinator as? MockNavigationCoordinator === dependencies.navigationCoordinator as? MockNavigationCoordinator)
        #expect(teamSelectInteractor.testHooks.dataManager as? MockDataManager === dependencies.dataManager as? MockDataManager)
    }
    
    @Test func testMakeTeamDetailInteractor() async throws {
        // Arrange
        let dependencies = MockDependencyContainer()
        let factory = InteractorFactory(dependencies: dependencies)
        let teamId = "test-team-id"
        
        // Act
        let interactor = factory.makeTeamDetailInteractor(teamId: teamId)
        
        // Assert
        guard let teamDetailInteractor = interactor as? TeamDetailInteractor else {
            Issue.record("Expected TeamDetailInteractor instance")
            return
        }
        
        // Verify dependencies were passed correctly
        #expect(teamDetailInteractor.testHooks.navigationCoordinator as? MockNavigationCoordinator === dependencies.navigationCoordinator as? MockNavigationCoordinator)
        #expect(teamDetailInteractor.testHooks.dataManager as? MockDataManager === dependencies.dataManager as? MockDataManager)
        
        // Verify teamId was passed correctly
        #expect(teamDetailInteractor.testHooks.teamId == teamId)
    }
    
    @Test func testMockInteractorFactory() async throws {
        // Arrange
        let factory = MockInteractorFactory()
        
        // Act & Assert TeamSelect
        let teamSelectInteractor = factory.makeTeamSelectInteractor()
        #expect(teamSelectInteractor is MockTeamSelectInteractor)
        
        // Act & Assert TeamDetail
        let teamDetailInteractor = factory.makeTeamDetailInteractor(teamId: "any-id")
        #expect(teamDetailInteractor is MockTeamDetailInteractor)
    }
}
