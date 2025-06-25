//
//  NewGameLocalDataSourceTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Combine
import Foundation
@testable import SuperSoccer
import Testing

struct NewGameLocalDataSourceTests {
    
    // MARK: - Initialization Tests
    
    @Test func testInitializationWithDefaultData() async throws {
        // Act
        let dataSource = NewGameLocalDataSource()
        
        // Assert
        #expect(dataSource.data.coachFirstName.isEmpty)
        #expect(dataSource.data.coachLastName.isEmpty)
        #expect(dataSource.data.selectedTeamInfo == nil)
        #expect(dataSource.data.canSubmit == false)
    }
    
    @Test func testInitializationWithCustomData() async throws {
        // Arrange
        let teamInfo = TeamInfo.make(id: "team1", city: "Test", teamName: "City")
        let customData = NewGameLocalDataSource.Data(
            coachFirstName: "John",
            coachLastName: "Doe",
            selectedTeamInfo: teamInfo
        )
        
        // Act
        let dataSource = NewGameLocalDataSource(data: customData)
        
        // Assert
        #expect(dataSource.data.coachFirstName == "John")
        #expect(dataSource.data.coachLastName == "Doe")
        #expect(dataSource.data.selectedTeamInfo?.id == "team1")
        #expect(dataSource.data.canSubmit == true)
    }
    
    // MARK: - Data Validation Tests
    
    @Test func testDataValidationWithEmptyFields() async throws {
        // Arrange
        var data = NewGameLocalDataSource.Data()
        
        // Act & Assert - All empty
        #expect(data.canSubmit == false)
        
        // Act & Assert - Only first name
        data.coachFirstName = "John"
        #expect(data.canSubmit == false)
        
        // Act & Assert - First and last name
        data.coachLastName = "Doe"
        #expect(data.canSubmit == false)
        
        // Act & Assert - All fields filled
        data.selectedTeamInfo = TeamInfo.make()
        #expect(data.canSubmit == true)
    }
    
    @Test func testDataValidationWithPartialData() async throws {
        // Arrange
        let teamInfo = TeamInfo.make()
        
        // Test with only team selected
        var data = NewGameLocalDataSource.Data(selectedTeamInfo: teamInfo)
        #expect(data.canSubmit == false)
        
        // Test with team and first name
        data.coachFirstName = "John"
        #expect(data.canSubmit == false)
        
        // Test with all required fields
        data.coachLastName = "Doe"
        #expect(data.canSubmit == true)
    }
    
    // MARK: - Update Methods Tests
    
    @Test func testUpdateCoachFirstName() async throws {
        // Arrange
        let dataSource = NewGameLocalDataSource()
        
        // Act
        dataSource.updateCoach(firstName: "TestFirstName")
        
        // Assert
        #expect(dataSource.data.coachFirstName == "TestFirstName")
        #expect(dataSource.data.coachLastName.isEmpty)
        #expect(dataSource.data.selectedTeamInfo == nil)
        #expect(dataSource.data.canSubmit == false)
    }
    
    @Test func testUpdateCoachLastName() async throws {
        // Arrange
        let dataSource = NewGameLocalDataSource()
        
        // Act
        dataSource.updateCoach(lastName: "TestLastName")
        
        // Assert
        #expect(dataSource.data.coachFirstName.isEmpty)
        #expect(dataSource.data.coachLastName == "TestLastName")
        #expect(dataSource.data.selectedTeamInfo == nil)
        #expect(dataSource.data.canSubmit == false)
    }
    
    @Test func testUpdateSelectedTeam() async throws {
        // Arrange
        let dataSource = NewGameLocalDataSource()
        let teamInfo = TeamInfo.make(id: "team123", city: "Manchester", teamName: "United")
        
        // Act
        dataSource.updateSelectedTeam(teamInfo)
        
        // Assert
        #expect(dataSource.data.coachFirstName.isEmpty)
        #expect(dataSource.data.coachLastName.isEmpty)
        #expect(dataSource.data.selectedTeamInfo?.id == "team123")
        #expect(dataSource.data.selectedTeamInfo?.city == "Manchester")
        #expect(dataSource.data.selectedTeamInfo?.teamName == "United")
        #expect(dataSource.data.canSubmit == false)
    }
    
    @Test func testUpdateSelectedTeamWithNil() async throws {
        // Arrange
        let teamInfo = TeamInfo.make()
        let initialData = NewGameLocalDataSource.Data(
            coachFirstName: "John",
            coachLastName: "Doe",
            selectedTeamInfo: teamInfo
        )
        let dataSource = NewGameLocalDataSource(data: initialData)
        
        // Verify initial state
        #expect(dataSource.data.canSubmit == true)
        
        // Act
        dataSource.updateSelectedTeam(nil)
        
        // Assert
        #expect(dataSource.data.coachFirstName == "John")
        #expect(dataSource.data.coachLastName == "Doe")
        #expect(dataSource.data.selectedTeamInfo == nil)
        #expect(dataSource.data.canSubmit == false)
    }
    
    // MARK: - Publisher Tests
    
    @Test func testDataPublisherEmitsUpdates() async throws {
        // Arrange
        let dataSource = NewGameLocalDataSource()
        var receivedData: [NewGameLocalDataSource.Data] = []
        let cancellable = dataSource.dataPublisher
            .sink { data in
                receivedData.append(data)
            }
        
        // Act
        dataSource.updateCoach(firstName: "John")
        dataSource.updateCoach(lastName: "Doe")
        dataSource.updateSelectedTeam(TeamInfo.make(id: "team1"))
        
        // Wait for publisher updates
        try await Task.sleep(nanoseconds: 100_000_000) // 0.1 seconds
        
        // Assert
        #expect(receivedData.count >= 4) // Initial + 3 updates
        #expect(receivedData.last?.coachFirstName == "John")
        #expect(receivedData.last?.coachLastName == "Doe")
        #expect(receivedData.last?.selectedTeamInfo?.id == "team1")
        #expect(receivedData.last?.canSubmit == true)
        
        cancellable.cancel()
    }
    
    @Test func testDataPublisherEmitsInitialValue() async throws {
        // Arrange
        let teamInfo = TeamInfo.make(id: "initial-team")
        let initialData = NewGameLocalDataSource.Data(
            coachFirstName: "Initial",
            coachLastName: "Coach",
            selectedTeamInfo: teamInfo
        )
        let dataSource = NewGameLocalDataSource(data: initialData)
        
        var receivedData: NewGameLocalDataSource.Data?
        let cancellable = dataSource.dataPublisher
            .sink { data in
                receivedData = data
            }
        
        // Wait for initial value
        try await Task.sleep(nanoseconds: 50_000_000) // 0.05 seconds
        
        // Assert
        #expect(receivedData?.coachFirstName == "Initial")
        #expect(receivedData?.coachLastName == "Coach")
        #expect(receivedData?.selectedTeamInfo?.id == "initial-team")
        #expect(receivedData?.canSubmit == true)
        
        cancellable.cancel()
    }
    
    // MARK: - Sequential Updates Tests
    
    @Test func testSequentialUpdatesCreateValidData() async throws {
        // Arrange
        let dataSource = NewGameLocalDataSource()
        let teamInfo = TeamInfo.make(id: "final-team", city: "Final", teamName: "Team")
        
        // Act - Update in sequence
        dataSource.updateCoach(firstName: "Sequential")
        #expect(dataSource.data.canSubmit == false)
        
        dataSource.updateCoach(lastName: "Test")
        #expect(dataSource.data.canSubmit == false)
        
        dataSource.updateSelectedTeam(teamInfo)
        #expect(dataSource.data.canSubmit == true)
        
        // Assert final state
        #expect(dataSource.data.coachFirstName == "Sequential")
        #expect(dataSource.data.coachLastName == "Test")
        #expect(dataSource.data.selectedTeamInfo?.id == "final-team")
        #expect(dataSource.data.selectedTeamInfo?.city == "Final")
        #expect(dataSource.data.selectedTeamInfo?.teamName == "Team")
    }
    
    @Test func testOverwritingExistingData() async throws {
        // Arrange
        let initialTeam = TeamInfo.make(id: "initial", city: "Initial", teamName: "Team")
        let initialData = NewGameLocalDataSource.Data(
            coachFirstName: "Old",
            coachLastName: "Coach",
            selectedTeamInfo: initialTeam
        )
        let dataSource = NewGameLocalDataSource(data: initialData)
        
        // Verify initial state
        #expect(dataSource.data.canSubmit == true)
        
        // Act - Overwrite data
        dataSource.updateCoach(firstName: "New")
        dataSource.updateCoach(lastName: "Manager")
        
        let newTeam = TeamInfo.make(id: "new", city: "New", teamName: "Club")
        dataSource.updateSelectedTeam(newTeam)
        
        // Assert
        #expect(dataSource.data.coachFirstName == "New")
        #expect(dataSource.data.coachLastName == "Manager")
        #expect(dataSource.data.selectedTeamInfo?.id == "new")
        #expect(dataSource.data.selectedTeamInfo?.city == "New")
        #expect(dataSource.data.selectedTeamInfo?.teamName == "Club")
        #expect(dataSource.data.canSubmit == true)
    }
    
    // MARK: - Edge Cases
    
    @Test func testUpdateWithEmptyStrings() async throws {
        // Arrange
        let initialData = NewGameLocalDataSource.Data(
            coachFirstName: "John",
            coachLastName: "Doe",
            selectedTeamInfo: TeamInfo.make()
        )
        let dataSource = NewGameLocalDataSource(data: initialData)
        
        // Verify initial valid state
        #expect(dataSource.data.canSubmit == true)
        
        // Act - Update with empty strings
        dataSource.updateCoach(firstName: "")
        #expect(dataSource.data.canSubmit == false)
        
        dataSource.updateCoach(lastName: "")
        #expect(dataSource.data.canSubmit == false)
        
        // Assert
        #expect(dataSource.data.coachFirstName.isEmpty)
        #expect(dataSource.data.coachLastName.isEmpty)
        #expect(dataSource.data.selectedTeamInfo != nil)
        #expect(dataSource.data.canSubmit == false)
    }
    
    @Test func testUpdateWithWhitespaceStrings() async throws {
        // Arrange
        let dataSource = NewGameLocalDataSource()
        
        // Act
        dataSource.updateCoach(firstName: "   ")
        dataSource.updateCoach(lastName: "   ")
        dataSource.updateSelectedTeam(TeamInfo.make())
        
        // Assert - Whitespace strings are not considered empty by isEmpty
        #expect(dataSource.data.coachFirstName == "   ")
        #expect(dataSource.data.coachLastName == "   ")
        #expect(dataSource.data.canSubmit == true) // Because isEmpty returns false for whitespace
    }
}
