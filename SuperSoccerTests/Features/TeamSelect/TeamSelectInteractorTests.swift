//
//  TeamSelectInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Combine
import Observation
@testable import SuperSoccer
import Testing

struct TeamSelectInteractorTests {
    @Test func testInitialViewModel() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        
        // Act
        let interactor = TeamSelectInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Assert initial state before any updates
        #expect(interactor.viewModel.title == "Select a team")
        #expect(interactor.viewModel.teamModels.isEmpty)
    }
    
    @Test func testViewModelUpdatesWithTeams() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        
        let mockTeams = [
            Team.make(
                id: "1",
                info: TeamInfo.make(
                    city: "Portland",
                    teamName: "Trail Blazers"
                )
            ),
            Team.make(
                id: "2",
                info: TeamInfo.make(
                    city: "Golden State",
                    teamName: "Warriors"
                )
            )
        ]
        
        // Act
        let interactor = TeamSelectInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        await confirmation { confirm in
            withObservationTracking {
                _ = interactor.viewModel
            } onChange: {
                confirm()
            }
            mockDataManager.mockTeams = mockTeams
        }
        
        // Assert
        #expect(interactor.viewModel.title == "Select a team")
        #expect(interactor.viewModel.teamModels.count == 2)
        #expect(interactor.viewModel.teamModels[0].text == "Portland Trail Blazers")
        #expect(interactor.viewModel.teamModels[1].text == "Golden State Warriors")
    }
    
    @Test func testTeamSelectionNavigatesToDetail() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        let selectedTeamId = "1"
        
        let interactor = TeamSelectInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Act
        interactor.eventBus.send(.teamSelected(teamInfoId: selectedTeamId))
        
        // Assert
        #expect(mockNavigationCoordinator.screenNavigatedTo == .teamDetail(teamId: selectedTeamId))
    }
    
    @Test func testViewModelUpdatesWhenTeamsChange() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockNavigationCoordinator = MockNavigationCoordinator()
        
        let initialTeams = [
            Team.make(
                id: "1",
                info: TeamInfo.make(
                    city: "Portland",
                    teamName: "Trail Blazers"
                )
            )
        ]
        
        let updatedTeams = [
            Team.make(
                id: "1",
                info: TeamInfo.make(
                    city: "Portland",
                    teamName: "Trail Blazers"
                )
            ),
            Team.make(
                id: "2",
                info: TeamInfo.make(
                    city: "Golden State",
                    teamName: "Warriors"
                )
            )
        ]
        
        // Act
        let interactor = TeamSelectInteractor(
            navigationCoordinator: mockNavigationCoordinator,
            dataManager: mockDataManager
        )
        
        // Wait for first update
        await confirmation { confirm in
            withObservationTracking {
                _ = interactor.viewModel
            } onChange: {
                confirm()
            }
            mockDataManager.mockTeams = initialTeams
        }
        
        // Wait for second update
        await confirmation { confirm in
            withObservationTracking {
                _ = interactor.viewModel
            } onChange: {
                confirm()
            }
            mockDataManager.mockTeams = updatedTeams
        }
        
        // Assert
        #expect(interactor.viewModel.teamModels.count == 2)
        #expect(interactor.viewModel.teamModels[0].text == "Portland Trail Blazers")
        #expect(interactor.viewModel.teamModels[1].text == "Golden State Warriors")
    }
}
