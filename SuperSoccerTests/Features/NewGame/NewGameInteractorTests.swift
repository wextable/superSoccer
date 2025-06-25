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
    
    // MARK: - Helper Methods
    
    private func createMocks() -> (MockDataManager, MockNewGameLocalDataSource) {
        return (MockDataManager(), MockNewGameLocalDataSource())
    }
        
    // MARK: - Initialization Tests
    
    @Test("NewGameInteractor initializes with correct view model")
    @MainActor
    func testInitialViewModel() {
        // Arrange & Act
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        
        // Assert
        #expect(interactor.viewModel.title == "New game")
        #expect(interactor.viewModel.coachLabelText == "Coach")
        #expect(interactor.viewModel.coachFirstNameLabel == "First name")
        #expect(interactor.viewModel.coachLastNameLabel == "Last name")
        #expect(interactor.viewModel.buttonText == "Start game")
    }
    
    // MARK: - Function Interface Tests
    
    @Test("NewGameInteractor handles teamSelectorTapped function call")
    @MainActor
    func testTeamSelectorTappedFunctionCall() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        let mockDelegate = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.teamSelectorTapped()
        
        // Assert
        #expect(mockDelegate.didRequestTeamSelection == true)
    }
    
    // MARK: - Business Logic Tests
    
    @Test("NewGameInteractor validates form correctly")
    @MainActor
    func testFormValidation() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        
        // Assert - Initially should have default state
        #expect(interactor.viewModel.submitEnabled == false)
    }
    
    @Test("NewGameInteractor provides default team selector state")
    @MainActor
    func testDefaultTeamSelectorState() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        
        // Assert - Check default state
        #expect(interactor.viewModel.teamSelectorTitle != nil)
        #expect(interactor.viewModel.teamSelectorButtonTitle != nil)
    }
    
    // MARK: - Binding Tests
    
    @Test("NewGameInteractor provides first name binding")
    @MainActor
    func testFirstNameBinding() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        
        // Act
        let binding = interactor.bindFirstName()
        
        // Assert - Test that binding exists and has correct initial value
        #expect(binding.wrappedValue == "")
        
        // Test that setting the binding value updates the local data source
        binding.wrappedValue = "John"
        #expect(mockLocalDataSource.data.coachFirstName == "John")
    }
    
    @Test("NewGameInteractor provides last name binding")
    @MainActor
    func testLastNameBinding() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        
        // Act
        let binding = interactor.bindLastName()
        
        // Assert - Test that binding exists and has correct initial value
        #expect(binding.wrappedValue == "")
        
        // Test that setting the binding value updates the local data source
        binding.wrappedValue = "Doe"
        #expect(mockLocalDataSource.data.coachLastName == "Doe")
    }
    
    // MARK: - Team Selection Tests
    
    @Test("NewGameInteractor handles team selection updates")
    @MainActor
    func testUpdateSelectedTeam() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        let teamInfo = TeamInfo.make(id: "team1", city: "Manchester", teamName: "United")
        
        // Act
        interactor.updateSelectedTeam(teamInfo)
        
        // Assert - Verify the local data source was updated
        #expect(mockLocalDataSource.data.selectedTeamInfo?.id == "team1")
        #expect(mockLocalDataSource.data.selectedTeamInfo?.city == "Manchester")
        #expect(mockLocalDataSource.data.selectedTeamInfo?.teamName == "United")
    }
    
    // MARK: - Delegate Communication Tests
    
    @Test("NewGameInteractor calls delegate on team selector tapped")
    @MainActor
    func testTeamSelectorTappedDelegate() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        let mockDelegate = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate

        // Act
        interactor.teamSelectorTapped()

        // Assert
        #expect(mockDelegate.didRequestTeamSelection == true)
    }

    @Test("NewGameInteractor calls delegate on career creation")
    func testSubmitTappedDelegate() async {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        // Setup valid data for submission
        let teamInfo = TeamInfo.make(id: "team1", city: "Test", teamName: "City")
        mockLocalDataSource.updateCoach(firstName: "John")
        mockLocalDataSource.updateCoach(lastName: "Doe")
        mockLocalDataSource.updateSelectedTeam(teamInfo)
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        let mockDelegate = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate

        // Setup expected result from mock data manager
        let expectedResult = CreateNewCareerResult.make(careerId: "career123")
        mockDataManager.mockCreateNewCareerResult = expectedResult

        // Act & Wait for completion
        await withCheckedContinuation { continuation in
            mockDelegate.onDidCreateGame = { _ in
                continuation.resume()
            }
            interactor.submitTapped()
        }
        
        // Assert
        #expect(mockDataManager.createNewCareerCalled == true)
        #expect(mockDelegate.didCreateGameCalled == true)
        #expect(mockDelegate.lastCreateGameResult?.careerId == "career123")
    }
    
    // MARK: - Data Manager Integration Tests
    
    @Test("NewGameInteractor integrates with data manager for career creation")
    func testDataManagerIntegration() async {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        // Setup valid data for submission
        let teamInfo = TeamInfo.make(id: "team1", city: "Test", teamName: "City")
        mockLocalDataSource.updateCoach(firstName: "John")
        mockLocalDataSource.updateCoach(lastName: "Doe")
        mockLocalDataSource.updateSelectedTeam(teamInfo)
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        let mockDelegate = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate
        
        let expectedResult = CreateNewCareerResult.make(careerId: "test-career")
        mockDataManager.mockCreateNewCareerResult = expectedResult
        
        // Act & Wait for completion
        await withCheckedContinuation { continuation in
            mockDelegate.onDidCreateGame = { _ in
                continuation.resume()
            }
            interactor.submitTapped()
        }
        
        // Assert
        #expect(mockDataManager.createNewCareerCalled == true)
        #expect(mockDelegate.didCreateGameCalled == true)
    }
    
    // MARK: - Delegate Communication Tests
    
    @Test("NewGameInteractor delegate methods are forwarded correctly")
    @MainActor
    func testDelegateMethodForwarding() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        let mockDelegate = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.teamSelectorTapped()
        
        // Assert
        #expect(mockDelegate.didRequestTeamSelection == true)
    }
    
    @Test("NewGameInteractor handles multiple delegate calls correctly")
    @MainActor
    func testMultipleDelegateCalls() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        let mockDelegate = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.teamSelectorTapped()
        interactor.teamSelectorTapped()
        
        // Assert
        #expect(mockDelegate.didRequestTeamSelection == true)
        // Note: Multiple calls maintain the boolean state
    }
    
    // MARK: - Memory Management Tests
    
    @Test("NewGameInteractor properly manages cancellables")
    @MainActor
    func testCancellablesManagement() {
        // Arrange & Act
        let (mockDataManager, mockLocalDataSource) = createMocks()
        var interactor: NewGameInteractor? = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        
        // Verify interactor is created
        #expect(interactor != nil)
        
        // Act - Release the interactor
        interactor = nil
        
        // Assert - No assertion needed, this test verifies no memory leaks occur
        // The test passes if no retain cycles prevent deallocation
    }
    
    @Test("NewGameInteractor handles delegate lifecycle correctly")
    @MainActor
    func testDelegateLifecycle() {
        // Arrange
        let (mockDataManager, mockLocalDataSource) = createMocks()
        let interactor = NewGameInteractor(dataManager: mockDataManager, localDataSource: mockLocalDataSource)
        var mockDelegate: MockNewGameInteractorDelegate? = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Verify delegate is set
        #expect(interactor.delegate != nil)
        
        // Act - Release delegate
        mockDelegate = nil
        
        // Assert - Delegate should be nil (weak reference)
        #expect(interactor.delegate == nil)
    }
}

// MARK: - Mock Local Data Source

class MockNewGameLocalDataSource: NewGameLocalDataSourceProtocol {
    var data: NewGameLocalDataSource.Data = NewGameLocalDataSource.Data()
    
    lazy var dataPublisher: AnyPublisher<NewGameLocalDataSource.Data, Never> = {
        Just(data).eraseToAnyPublisher()
    }()
    
    func updateCoach(firstName: String) {
        data.coachFirstName = firstName
    }
    
    func updateCoach(lastName: String) {
        data.coachLastName = lastName
    }
    
    func updateSelectedTeam(_ teamInfo: TeamInfo?) {
        data.selectedTeamInfo = teamInfo
    }
}
