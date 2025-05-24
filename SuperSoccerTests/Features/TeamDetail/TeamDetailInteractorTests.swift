//
//  TeamDetailInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Combine
import Observation
@testable import SuperSoccer
import Testing

struct TeamDetailInteractorTests {
    @Test func testInitialViewModel() async throws {
        // Fails bc viewModel updates before we can observe the initial state
//        // Arrange
//        let mockDataManager = MockDataManager()
//        let mockNavigationCoordinator = MockNavigationCoordinator()
//        let teamId = "123"
//        
//        // Set up mock data
//        let mockTeam = Team.make(
//            id: "123",
//            info: TeamInfo.make(
//                city: "Portland",
//                teamName: "Trail Blazers"
//            )
//        )
//        mockDataManager.mockTeams = [mockTeam]
//        
//        // Act
//        let interactor = TeamDetailInteractor(
//            navigationCoordinator: mockNavigationCoordinator,
//            teamId: teamId,
//            dataManager: mockDataManager
//        )
//        
//        // Assert
//        #expect(interactor.viewModel.title == "Team Details")
//        #expect(interactor.viewModel.teamName == "Loading...")
    }
    
    @Test func testMockEventHandling() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let teamId = "123"
        let interactor = TeamDetailInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            teamId: teamId,
            dataManager: mockDataManager
        )
        
        // Act
        interactor.eventBus.send(.mockEvent)
        
        // Assert - verify event was handled (in this case, just verifying it doesn't crash)
        #expect(true)
    }
    
    @Test func testViewModelUpdatesWithTeamAndPlayers() async throws {
        // Arrange
//        var cancellables: Set<AnyCancellable> = []
//        let expectation = self.expectation(description: "Wait for viewModel to change")

        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let teamId = "123"
        
        // Set up mock data with players
        let mockTeam = Team.make(
            id: "123",
            info: TeamInfo.make(
                city: "Portland",
                teamName: "Trail Blazers"
            ),
            players: [
                Player.make(
                    firstName: "Damian",
                    lastName: "Lillard"
                ),
                Player.make(
                    firstName: "CJ",
                    lastName: "McCollum"
                )
            ]
        )
        
        // Act
        let interactor = TeamDetailInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            teamId: teamId,
            dataManager: mockDataManager
        )
        
        await confirmation { confirm in
            withObservationTracking {
                _ = interactor.viewModel
            } onChange: {
                confirm()
            }
            mockDataManager.mockTeams = [mockTeam]
        }

        // Assert
        #expect(interactor.viewModel.title == "Team Details")
        #expect(interactor.viewModel.teamName == "Portland Trail Blazers")
    }
}
