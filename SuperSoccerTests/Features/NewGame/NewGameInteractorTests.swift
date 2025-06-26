//
//  NewGameInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/23/25.
//

import Combine
import Foundation
import Observation
@testable import SuperSoccer
import SwiftUI
import Testing

struct NewGameInteractorTests {
    
    // MARK: - Helper Methods
    
    private func createMocks() -> (MockDataManager, MockNewGameLocalDataSource, MockNewGameViewModelTransform) {
        return (
            MockDataManager(), 
            MockNewGameLocalDataSource(), 
            MockNewGameViewModelTransform() // Fresh instance each time
        )
    }
        
    // MARK: - Initialization Tests
    
    @Test("NewGameInteractor initializes with correct dependencies")
    @MainActor
    func testInitializationWithDependencies() {
        // Arrange & Act
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Assert
        #expect(interactor != nil)
        // Note: Transform may be called during subscription setup (async)
    }

    @Test("NewGameInteractor implements NewGameInteractorProtocol correctly")
    @MainActor
    func testProtocolCompliance() {
        // Arrange & Act
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Assert - Test protocol compliance
        let businessLogic: NewGameBusinessLogic = interactor
        let viewPresenter: NewGameViewPresenter = interactor
        let interactorProtocol: NewGameInteractorProtocol = interactor
        
        #expect(businessLogic != nil)
        #expect(viewPresenter != nil)
        #expect(interactorProtocol != nil)
    }
    
    // MARK: - ViewModelTransform Integration Tests

    @Test("NewGameInteractor uses ViewModelTransform for view model creation")
    @MainActor
    func testViewModelTransformIntegration() async {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let expectedViewModel = NewGameViewModel.make(
            title: "Test Game",
            coachFirstName: "Test",
            submitEnabled: true
        )
        mockTransform.mockViewModel = expectedViewModel
        
        // Act
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Wait for async subscription setup
        try? await Task.sleep(for: .milliseconds(50))
        
        // Assert
        #expect(mockTransform.didCallTransform == true)
        #expect(interactor.viewModel.title == "Test Game")
        #expect(interactor.viewModel.coachFirstName == "Test")
        #expect(interactor.viewModel.submitEnabled == true)
    }

    @Test("NewGameInteractor updates view model when local data changes")
    @MainActor
    func testViewModelUpdatesWithDataChanges() async {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Wait for initial subscription setup and then clear the flag
        try? await Task.sleep(for: .milliseconds(50))
        mockTransform.didCallTransform = false // Reset after initialization
        
        let updatedViewModel = NewGameViewModel.make(
            coachFirstName: "Updated",
            coachLastName: "Name"
        )
        mockTransform.mockViewModel = updatedViewModel
        
        // Act - Update local data to trigger transformation
        mockLocalDataSource.updateCoach(firstName: "Updated")
        
        // Wait for async subscription update
        try? await Task.sleep(for: .milliseconds(100)) // Increased wait time
        
        // Assert
        #expect(mockTransform.didCallTransform == true, "Transform should be called after data update")
        #expect(interactor.viewModel.coachFirstName == "Updated")
        #expect(interactor.viewModel.coachLastName == "Name")
    }
    
    // MARK: - Nested ViewModel Pattern Tests
    
    @Test("NewGameInteractor provides nested TeamSelectorViewModel")
    @MainActor
    func testNestedTeamSelectorViewModel() async {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let teamSelectorModel = TeamSelectorViewModel.make(
            title: "Manchester United",
            buttonTitle: "Change"
        )
        let expectedViewModel = NewGameViewModel.make(
            teamSelectorModel: teamSelectorModel
        )
        mockTransform.mockViewModel = expectedViewModel
        
        // Act
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Wait for async subscription setup
        try? await Task.sleep(for: .milliseconds(50))
        
        // Assert - Verify nested view model is correctly provided
        #expect(interactor.viewModel.teamSelectorModel.title == "Manchester United")
        #expect(interactor.viewModel.teamSelectorModel.buttonTitle == "Change")
    }

    @Test("NewGameInteractor updates nested TeamSelectorViewModel on team selection")
    @MainActor
    func testNestedViewModelUpdatesOnTeamSelection() async {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Wait for initial subscription setup and then clear the flag
        try? await Task.sleep(for: .milliseconds(50))
        mockTransform.didCallTransform = false // Reset after initialization
        
        let updatedTeamSelectorModel = TeamSelectorViewModel.make(
            title: "Liverpool FC",
            buttonTitle: "Change"
        )
        let updatedViewModel = NewGameViewModel.make(
            teamSelectorModel: updatedTeamSelectorModel
        )
        mockTransform.mockViewModel = updatedViewModel
        
        // Act
        let teamInfo = TeamInfo.make(city: "Liverpool", teamName: "FC")
        interactor.updateSelectedTeam(teamInfo)
        
        // Wait for async subscription update
        try? await Task.sleep(for: .milliseconds(100)) // Increased wait time
        
        // Assert
        #expect(mockTransform.didCallTransform == true, "Transform should be called after team selection")
        #expect(interactor.viewModel.teamSelectorModel.title == "Liverpool FC")
        #expect(interactor.viewModel.teamSelectorModel.buttonTitle == "Change")
    }
    
    // MARK: - Function Interface Tests
    
    @Test("NewGameInteractor handles teamSelectorTapped function call")
    @MainActor
    func testTeamSelectorTappedFunctionCall() {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        let mockDelegate = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.teamSelectorTapped()
        
        // Assert
        #expect(mockDelegate.didRequestTeamSelection == true)
    }
    
    // MARK: - Binding Tests
    
    @Test("NewGameInteractor provides first name binding")
    @MainActor
    func testFirstNameBinding() async {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Wait for initial setup
        try? await Task.sleep(for: .milliseconds(50))
        
        // Act
        let binding = interactor.bindFirstName()
        
        // Assert - Test that binding exists and gets value from view model
        #expect(binding.wrappedValue == interactor.viewModel.coachFirstName)
        
        // Test that setting the binding value updates the local data source
        binding.wrappedValue = "John"
        #expect(mockLocalDataSource.data.coachFirstName == "John")
    }
    
    @Test("NewGameInteractor provides last name binding")
    @MainActor
    func testLastNameBinding() async {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Wait for initial setup
        try? await Task.sleep(for: .milliseconds(50))
        
        // Act
        let binding = interactor.bindLastName()
        
        // Assert - Test that binding exists and gets value from view model
        #expect(binding.wrappedValue == interactor.viewModel.coachLastName)
        
        // Test that setting the binding value updates the local data source
        binding.wrappedValue = "Doe"
        #expect(mockLocalDataSource.data.coachLastName == "Doe")
    }
    
    // MARK: - Team Selection Tests
    
    @Test("NewGameInteractor handles team selection updates")
    @MainActor
    func testUpdateSelectedTeam() {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
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
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
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
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        // Setup valid data for submission
        let teamInfo = TeamInfo.make(id: "team1", city: "Test", teamName: "City")
        mockLocalDataSource.updateCoach(firstName: "John")
        mockLocalDataSource.updateCoach(lastName: "Doe")
        mockLocalDataSource.updateSelectedTeam(teamInfo)
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
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
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        // Setup valid data for submission
        let teamInfo = TeamInfo.make(id: "team1", city: "Test", teamName: "City")
        mockLocalDataSource.updateCoach(firstName: "John")
        mockLocalDataSource.updateCoach(lastName: "Doe")
        mockLocalDataSource.updateSelectedTeam(teamInfo)
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
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
        #expect(mockDelegate.lastCreateGameResult?.careerId == "test-career")
    }
    
    // MARK: - Memory Management Tests
    
    @Test("NewGameInteractor handles delegate lifecycle correctly")
    @MainActor
    func testDelegateLifecycle() {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        var mockDelegate: MockNewGameInteractorDelegate? = MockNewGameInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act - Clear delegate reference
        mockDelegate = nil
        
        // Assert - Interactor should handle weak delegate gracefully
        #expect(interactor.delegate == nil)
    }
    
    // MARK: - Edge Cases
    
    @Test("NewGameInteractor handles edge cases gracefully")
    @MainActor
    func testEdgeCaseHandling() {
        // Arrange
        let (mockDataManager, mockLocalDataSource, mockTransform) = createMocks()
        let interactor = NewGameInteractor(
            dataManager: mockDataManager, 
            localDataSource: mockLocalDataSource,
            newGameViewModelTransform: mockTransform
        )
        
        // Act & Assert - Should handle nil team selection gracefully
        interactor.updateSelectedTeam(TeamInfo.make(id: "", city: "", teamName: ""))
        #expect(mockLocalDataSource.data.selectedTeamInfo != nil)
        
        // Act & Assert - Should handle empty name inputs gracefully
        let firstNameBinding = interactor.bindFirstName()
        let lastNameBinding = interactor.bindLastName()
        firstNameBinding.wrappedValue = ""
        lastNameBinding.wrappedValue = ""
        #expect(mockLocalDataSource.data.coachFirstName == "")
        #expect(mockLocalDataSource.data.coachLastName == "")
    }
}

// MARK: - Mock Local Data Source

class MockNewGameLocalDataSource: NewGameLocalDataSourceProtocol {
    var data: NewGameLocalDataSource.Data = NewGameLocalDataSource.Data()
    
    private let dataSubject = CurrentValueSubject<NewGameLocalDataSource.Data, Never>(NewGameLocalDataSource.Data())
    
    lazy var dataPublisher: AnyPublisher<NewGameLocalDataSource.Data, Never> = {
        dataSubject.eraseToAnyPublisher()
    }()
    
    func updateCoach(firstName: String) {
        data.coachFirstName = firstName
        dataSubject.send(data) // Notify subscribers of the change
    }
    
    func updateCoach(lastName: String) {
        data.coachLastName = lastName
        dataSubject.send(data) // Notify subscribers of the change
    }
    
    func updateSelectedTeam(_ teamInfo: TeamInfo?) {
        data.selectedTeamInfo = teamInfo
        dataSubject.send(data) // Notify subscribers of the change
    }
}
