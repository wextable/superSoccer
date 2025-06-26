//
//  NewGameViewModelTransformTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/26/25.
//

import Foundation
@testable import SuperSoccer
import Testing

struct NewGameViewModelTransformTests {
    
    // MARK: - Initialization Tests
    
    @Test("NewGameViewModelTransform initializes correctly")
    func testInitialization() {
        // Arrange & Act
        let transform = NewGameViewModelTransform()
        
        // Assert
        #expect(transform != nil)
    }
    
    @Test("NewGameViewModelTransform conforms to protocol")
    func testProtocolConformance() {
        // Arrange & Act
        let transform: NewGameViewModelTransformProtocol = NewGameViewModelTransform()
        
        // Assert
        #expect(transform != nil)
    }
    
    // MARK: - Basic Transformation Tests
    
    @Test("NewGameViewModelTransform creates correct basic view model")
    func testBasicViewModelCreation() {
        // Arrange
        let transform = NewGameViewModelTransform()
        let localData = NewGameLocalDataSource.Data(
            coachFirstName: "John",
            coachLastName: "Doe",
            selectedTeamInfo: nil
        )
        
        // Act
        let viewModel = transform.transform(localData: localData)
        
        // Assert
        #expect(viewModel.title == "New game")
        #expect(viewModel.coachLabelText == "Coach")
        #expect(viewModel.coachFirstNameLabel == "First name")
        #expect(viewModel.coachFirstName == "John")
        #expect(viewModel.coachLastNameLabel == "Last name")
        #expect(viewModel.coachLastName == "Doe")
        #expect(viewModel.buttonText == "Start game")
        #expect(viewModel.submitEnabled == false) // No team selected
    }
    
    @Test("NewGameViewModelTransform handles complete valid data")
    func testCompleteValidDataTransformation() {
        // Arrange
        let transform = NewGameViewModelTransform()
        let teamInfo = TeamInfo.make(id: "team1", city: "Manchester", teamName: "United")
        let localData = NewGameLocalDataSource.Data(
            coachFirstName: "Alex",
            coachLastName: "Ferguson",
            selectedTeamInfo: teamInfo
        )
        
        // Act
        let viewModel = transform.transform(localData: localData)
        
        // Assert
        #expect(viewModel.coachFirstName == "Alex")
        #expect(viewModel.coachLastName == "Ferguson")
        #expect(viewModel.submitEnabled == true) // Complete data
    }
    
    // MARK: - Nested ViewModel Tests
    
    @Test("NewGameViewModelTransform creates correct TeamSelectorViewModel with no team")
    func testTeamSelectorViewModelWithNoTeam() {
        // Arrange
        let transform = NewGameViewModelTransform()
        let localData = NewGameLocalDataSource.Data(
            coachFirstName: "John",
            coachLastName: "Doe",
            selectedTeamInfo: nil
        )
        
        // Act
        let viewModel = transform.transform(localData: localData)
        
        // Assert
        let teamSelectorModel = viewModel.teamSelectorModel
        #expect(teamSelectorModel.title == "Team:")
        #expect(teamSelectorModel.buttonTitle == "Select your team")
    }
    
    @Test("NewGameViewModelTransform creates correct TeamSelectorViewModel with selected team")
    func testTeamSelectorViewModelWithSelectedTeam() {
        // Arrange
        let transform = NewGameViewModelTransform()
        let teamInfo = TeamInfo.make(id: "team1", city: "Liverpool", teamName: "FC")
        let localData = NewGameLocalDataSource.Data(
            coachFirstName: "Jurgen",
            coachLastName: "Klopp",
            selectedTeamInfo: teamInfo
        )
        
        // Act
        let viewModel = transform.transform(localData: localData)
        
        // Assert
        let teamSelectorModel = viewModel.teamSelectorModel
        #expect(teamSelectorModel.title == "Liverpool FC")
        #expect(teamSelectorModel.buttonTitle == "Change")
    }
    
    @Test("NewGameViewModelTransform updates TeamSelectorViewModel correctly on team changes")
    func testTeamSelectorViewModelUpdates() {
        // Arrange
        let transform = NewGameViewModelTransform()
        
        // Act & Assert - No team initially
        let initialData = NewGameLocalDataSource.Data(
            coachFirstName: "Test",
            coachLastName: "Coach",
            selectedTeamInfo: nil
        )
        let initialViewModel = transform.transform(localData: initialData)
        #expect(initialViewModel.teamSelectorModel.title == "Team:")
        #expect(initialViewModel.teamSelectorModel.buttonTitle == "Select your team")
        
        // Act & Assert - Team selected
        let teamInfo = TeamInfo.make(city: "Arsenal", teamName: "FC")
        let updatedData = NewGameLocalDataSource.Data(
            coachFirstName: "Test",
            coachLastName: "Coach",
            selectedTeamInfo: teamInfo
        )
        let updatedViewModel = transform.transform(localData: updatedData)
        #expect(updatedViewModel.teamSelectorModel.title == "Arsenal FC")
        #expect(updatedViewModel.teamSelectorModel.buttonTitle == "Change")
    }
    
    // MARK: - Submit Validation Tests
    
    @Test("NewGameViewModelTransform validates submit correctly for incomplete data")
    func testSubmitValidationIncompleteData() {
        // Arrange
        let transform = NewGameViewModelTransform()
        
        // Test cases for incomplete data
        let testCases: [(String, String, TeamInfo?, Bool)] = [
            ("", "", nil, false),                    // Nothing filled
            ("John", "", nil, false),                // Only first name
            ("", "Doe", nil, false),                 // Only last name
            ("John", "Doe", nil, false),             // No team selected
            ("", "", TeamInfo.make(), false),        // Only team selected
            ("John", "", TeamInfo.make(), false),    // First name + team
            ("", "Doe", TeamInfo.make(), false),     // Last name + team
        ]
        
        for (firstName, lastName, teamInfo, expectedEnabled) in testCases {
            // Act
            let localData = NewGameLocalDataSource.Data(
                coachFirstName: firstName,
                coachLastName: lastName,
                selectedTeamInfo: teamInfo
            )
            let viewModel = transform.transform(localData: localData)
            
            // Assert
            #expect(viewModel.submitEnabled == expectedEnabled,
                   "Expected submitEnabled=\(expectedEnabled) for firstName='\(firstName)', lastName='\(lastName)', teamInfo=\(teamInfo != nil)")
        }
    }
    
    @Test("NewGameViewModelTransform validates submit correctly for complete data")
    func testSubmitValidationCompleteData() {
        // Arrange
        let transform = NewGameViewModelTransform()
        let teamInfo = TeamInfo.make(id: "team1", city: "Chelsea", teamName: "FC")
        let localData = NewGameLocalDataSource.Data(
            coachFirstName: "Frank",
            coachLastName: "Lampard",
            selectedTeamInfo: teamInfo
        )
        
        // Act
        let viewModel = transform.transform(localData: localData)
        
        // Assert
        #expect(viewModel.submitEnabled == true)
    }
    
    // MARK: - Edge Case Tests
    
    @Test("NewGameViewModelTransform handles empty strings gracefully")
    func testEmptyStringHandling() {
        // Arrange
        let transform = NewGameViewModelTransform()
        let localData = NewGameLocalDataSource.Data(
            coachFirstName: "",
            coachLastName: "",
            selectedTeamInfo: nil
        )
        
        // Act
        let viewModel = transform.transform(localData: localData)
        
        // Assert
        #expect(viewModel.coachFirstName == "")
        #expect(viewModel.coachLastName == "")
        #expect(viewModel.submitEnabled == false)
        #expect(viewModel.teamSelectorModel.title == "Team:")
        #expect(viewModel.teamSelectorModel.buttonTitle == "Select your team")
    }
    
    @Test("NewGameViewModelTransform handles whitespace in names")
    func testWhitespaceHandling() {
        // Arrange
        let transform = NewGameViewModelTransform()
        let teamInfo = TeamInfo.make()
        let localData = NewGameLocalDataSource.Data(
            coachFirstName: "  John  ",
            coachLastName: "  Doe  ",
            selectedTeamInfo: teamInfo
        )
        
        // Act
        let viewModel = transform.transform(localData: localData)
        
        // Assert - Transform preserves whitespace (validation handled elsewhere)
        #expect(viewModel.coachFirstName == "  John  ")
        #expect(viewModel.coachLastName == "  Doe  ")
        #expect(viewModel.submitEnabled == true) // Still valid with whitespace
    }
    
    @Test("NewGameViewModelTransform handles team with empty city or name")
    func testTeamWithEmptyFields() {
        // Arrange
        let transform = NewGameViewModelTransform()
        
        // Test with empty city
        let teamWithEmptyCity = TeamInfo.make(id: "team1", city: "", teamName: "United")
        let dataWithEmptyCity = NewGameLocalDataSource.Data(
            coachFirstName: "Test",
            coachLastName: "Coach",
            selectedTeamInfo: teamWithEmptyCity
        )
        
        // Act
        let viewModelEmptyCity = transform.transform(localData: dataWithEmptyCity)
        
        // Assert
        #expect(viewModelEmptyCity.teamSelectorModel.title == " United") // Space + team name
        #expect(viewModelEmptyCity.teamSelectorModel.buttonTitle == "Change")
        
        // Test with empty team name
        let teamWithEmptyName = TeamInfo.make(id: "team2", city: "Manchester", teamName: "")
        let dataWithEmptyName = NewGameLocalDataSource.Data(
            coachFirstName: "Test",
            coachLastName: "Coach",
            selectedTeamInfo: teamWithEmptyName
        )
        
        // Act
        let viewModelEmptyName = transform.transform(localData: dataWithEmptyName)
        
        // Assert
        #expect(viewModelEmptyName.teamSelectorModel.title == "Manchester ") // City + space
        #expect(viewModelEmptyName.teamSelectorModel.buttonTitle == "Change")
    }
    
    // MARK: - Consistency Tests
    
    @Test("NewGameViewModelTransform produces consistent results")
    func testConsistentResults() {
        // Arrange
        let transform = NewGameViewModelTransform()
        let teamInfo = TeamInfo.make(id: "team1", city: "Tottenham", teamName: "Hotspur")
        let localData = NewGameLocalDataSource.Data(
            coachFirstName: "Harry",
            coachLastName: "Kane",
            selectedTeamInfo: teamInfo
        )
        
        // Act - Transform multiple times
        let viewModel1 = transform.transform(localData: localData)
        let viewModel2 = transform.transform(localData: localData)
        
        // Assert - Results should be identical
        #expect(viewModel1.title == viewModel2.title)
        #expect(viewModel1.coachFirstName == viewModel2.coachFirstName)
        #expect(viewModel1.coachLastName == viewModel2.coachLastName)
        #expect(viewModel1.submitEnabled == viewModel2.submitEnabled)
        #expect(viewModel1.teamSelectorModel.title == viewModel2.teamSelectorModel.title)
        #expect(viewModel1.teamSelectorModel.buttonTitle == viewModel2.teamSelectorModel.buttonTitle)
    }
} 