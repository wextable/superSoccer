//
//  TeamSelectInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Combine
import Foundation
import Observation
@testable import SuperSoccer
import Testing

struct TeamSelectInteractorTests {
    @Test func testInitialViewModel() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockTeamInfos = [
            TeamInfo.make(
                city: "Portland",
                teamName: "Trail Blazers"
            ),
            TeamInfo.make(
                city: "Golden State",
                teamName: "Warriors"
            )
        ]
        mockDataManager.mockTeamInfos = mockTeamInfos
        
        // Act
        let interactor = TeamSelectInteractor(dataManager: mockDataManager)
        
        // Assert
        #expect(interactor.viewModel.title == "Select a team")
        #expect(interactor.viewModel.teamModels.count == 2)
        let team1 = interactor.viewModel.teamModels.first
        try #require(team1 != nil)
        #expect(team1?.text == "Portland Trail Blazers")
        let team2 = interactor.viewModel.teamModels.last
        try #require(team2 != nil)
        #expect(team2?.text == "Golden State Warriors")
    }
}
