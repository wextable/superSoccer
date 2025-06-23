//
//  NewGameInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Combine
import Foundation
@testable import SuperSoccer
import SwiftUI
import Testing

struct NewGameInteractorTests {
    
    // MARK: - Initialization Tests
    
    @Test func testInitialViewModel() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        
        // Act
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        
        // Assert
        #expect(interactor.viewModel.title == "New game")
        #expect(interactor.viewModel.coachLabelText == "Coach")
        #expect(interactor.viewModel.coachFirstNameLabel == "First name")
        #expect(interactor.viewModel.coachLastNameLabel == "Last name")
        #expect(interactor.viewModel.buttonText == "Start game")
        #expect(interactor.viewModel.submitEnabled == false) // Initially invalid
    }
    
    @Test func testViewModelUpdatesWithLocalDataSource() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        
        // Wait for the viewModel to update by subscribing to the data publisher
        await withCheckedContinuation { continuation in
            var cancellable: AnyCancellable?
            cancellable = mockLocalDataSource.dataPublisher
                .dropFirst() // Skip the initial value
                .receive(on: DispatchQueue.main)
                .sink { _ in
                    cancellable?.cancel()
                    continuation.resume()
                }
            
            // Act - Update the data source (this will trigger the publisher)
            mockLocalDataSource.updateData(
                coachFirstName: "John",
                coachLastName: "Doe",
                selectedTeamInfo: TeamInfo.make(city: "Test", teamName: "City"),
                isValid: true
            )
        }
        
        // Assert
        #expect(interactor.viewModel.coachFirstName == "John")
        #expect(interactor.viewModel.coachLastName == "Doe")
        #expect(interactor.viewModel.submitEnabled == true)
        #expect(interactor.viewModel.teamSelectorTitle == "Test")
        #expect(interactor.viewModel.teamSelectorButtonTitle == "City")
    }
    
    // MARK: - Binding Tests
    
    @Test func testFirstNameBinding() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        
        // Act
        let binding = interactor.bindFirstName()
        binding.wrappedValue = "TestFirstName"
        
        // Assert
        #expect(mockLocalDataSource.lastUpdatedFirstName == "TestFirstName")
    }
    
    @Test func testLastNameBinding() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        
        // Act
        let binding = interactor.bindLastName()
        binding.wrappedValue = "TestLastName"
        
        // Assert
        #expect(mockLocalDataSource.lastUpdatedLastName == "TestLastName")
    }
    
    // MARK: - Team Selection Tests
    
    @Test func testUpdateSelectedTeam() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        
        let teamInfo = TeamInfo.make(id: "team1", city: "Manchester", teamName: "United")
        
        // Act
        interactor.updateSelectedTeam(teamInfo)
        
        // Assert
        #expect(mockLocalDataSource.lastUpdatedTeamInfo?.id == "team1")
        #expect(mockLocalDataSource.lastUpdatedTeamInfo?.city == "Manchester")
        #expect(mockLocalDataSource.lastUpdatedTeamInfo?.teamName == "United")
    }
    
    // MARK: - Event Bus Tests
    
    @Test func testTeamSelectorTappedEvent() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        let mockDelegate = MockNewGameInteractorDelegate()
        
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        interactor.delegate = mockDelegate
        
        // Act
        await withCheckedContinuation { continuation in
            mockDelegate.onDidRequestTeamSelection = {
                continuation.resume()
            }
            
            interactor.eventBus.send(.teamSelectorTapped)
        }
        
        // Assert
        #expect(mockDelegate.didRequestTeamSelection == true)
    }
    
    @Test func testSubmitTappedEventWithValidData() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        let mockDelegate = MockNewGameInteractorDelegate()
        
        // Setup valid data
        mockLocalDataSource.updateData(
            coachFirstName: "John",
            coachLastName: "Doe",
            selectedTeamInfo: TeamInfo.make(id: "team1", city: "Test", teamName: "City"),
            isValid: true
        )
        
        let expectedResult = CreateNewCareerResult.make(careerId: "career123")
        mockDataManager.mockCreateNewCareerResult = expectedResult
        
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        interactor.delegate = mockDelegate
        
        // Act
        await withCheckedContinuation { continuation in
            mockDelegate.onDidCreateGame = {
                continuation.resume()
            }
            
            interactor.eventBus.send(.submitTapped)
        }
        
        // Assert
        #expect(mockDataManager.createNewCareerCalled == true)
        #expect(mockDataManager.lastCreateNewCareerRequest?.coachFirstName == "John")
        #expect(mockDataManager.lastCreateNewCareerRequest?.coachLastName == "Doe")
        #expect(mockDataManager.lastCreateNewCareerRequest?.selectedTeamInfoId == "team1")
        #expect(mockDataManager.lastCreateNewCareerRequest?.leagueName == "Premier League")
        #expect(mockDataManager.lastCreateNewCareerRequest?.seasonYear == 2025)
        
        #expect(mockDelegate.didCreateGameCalled == true)
        #expect(mockDelegate.lastCreateGameResult?.careerId == "career123")
    }
    
    @Test func testSubmitTappedEventWithInvalidData() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        let mockDelegate = MockNewGameInteractorDelegate()
        
        // Setup invalid data (no team selected)
        mockLocalDataSource.updateData(
            coachFirstName: "John",
            coachLastName: "Doe",
            selectedTeamInfo: nil,
            isValid: false
        )
        
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        interactor.delegate = mockDelegate
        
        // Act
        interactor.eventBus.send(.submitTapped)
        
        // Wait a brief moment to ensure no async operations complete
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                continuation.resume()
            }
        }
        
        // Assert that nothing happened
        #expect(mockDataManager.createNewCareerCalled == false)
        #expect(mockDelegate.didCreateGameCalled == false)
    }
    
    // MARK: - ViewModel Creation Tests
    
    @Test func testViewModelCreationWithCompleteData() async throws {
        // Arrange
        let mockDataManager = MockDataManager()
        let mockLocalDataSource = MockNewGameLocalDataSource()
        
        let teamInfo = TeamInfo.make(id: "team1", city: "Liverpool", teamName: "FC")
        mockLocalDataSource.updateData(
            coachFirstName: "Jurgen",
            coachLastName: "Klopp",
            selectedTeamInfo: teamInfo,
            isValid: true
        )
        
        // Act
        let interactor = NewGameInteractor(
            dataManager: mockDataManager,
            localDataSource: mockLocalDataSource
        )
        
        // Wait a brief moment to ensure no async operations complete
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                continuation.resume()
            }
        }
        
        // Assert
        #expect(interactor.viewModel.coachFirstName == "Jurgen")
        #expect(interactor.viewModel.coachLastName == "Klopp")
        #expect(interactor.viewModel.submitEnabled == true)
        #expect(interactor.viewModel.teamSelectorTitle == "Liverpool FC")
        #expect(interactor.viewModel.teamSelectorButtonTitle == "Change")
    }
}
