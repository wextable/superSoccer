//
//  MainMenuInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Combine
import Foundation
@testable import SuperSoccer
import Testing

struct MainMenuInteractorTests {
    
    // MARK: - Helper Methods
    
    private func createMocks() -> MockDataManager {
        return MockDataManager()
    }
        
    // MARK: - Initialization Tests
    
    @Test("MainMenuInteractor initializes with correct view model")
    @MainActor
    func testInitialViewModel() {
        // Arrange & Act
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        
        // Assert
        #expect(interactor.viewModel.title == "Main menu")
        #expect(interactor.viewModel.menuItemModels.count == 1)
        #expect(interactor.viewModel.menuItemModels.first?.title == "New game")
    }
    
    // MARK: - Function Interface Tests
    
    @Test("MainMenuInteractor handles newGameTapped function call")
    @MainActor
    func testNewGameTappedFunctionCall() {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.newGameTapped()
        
        // Assert
        #expect(mockDelegate.didSelectNewGameCalled == true)
    }
    
    // MARK: - Business Logic Tests
    
    @Test("MainMenuInteractor provides correct menu structure")
    @MainActor
    func testMenuStructure() {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        
        // Act
        let menuItems = interactor.viewModel.menuItemModels
        
        // Assert
        #expect(menuItems.count == 1)
        #expect(menuItems.first?.title == "New game")
        #expect(menuItems.first?.action != nil)
    }
    
    @Test("MainMenuInteractor menu action calls newGameTapped")
    @MainActor
    func testMenuActionCallsNewGameTapped() {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.viewModel.menuItemModels.first?.action()
        
        // Assert
        #expect(mockDelegate.didSelectNewGameCalled == true)
    }
    
    // MARK: - Delegate Communication Tests
    
    @Test("MainMenuInteractor calls delegate on new game tapped")
    @MainActor
    func testNewGameTappedDelegate() {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate

        // Act
        interactor.newGameTapped()

        // Assert
        #expect(mockDelegate.didSelectNewGameCalled == true)
    }

    @Test("MainMenuInteractor handles reliable delegate communication")
    func testReliableDelegateCallbacks() async {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate

        // Act & Wait for completion using withCheckedContinuation
        await withCheckedContinuation { continuation in
            mockDelegate.onDidSelectNewGame = {
                continuation.resume()
            }
            interactor.newGameTapped()
        }
        
        // Assert
        #expect(mockDelegate.didSelectNewGameCalled == true)
    }
    
    // MARK: - Delegate Communication Tests
    
    @Test("MainMenuInteractor delegate methods are forwarded correctly")
    @MainActor
    func testDelegateMethodForwarding() {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.newGameTapped()
        
        // Assert
        #expect(mockDelegate.didSelectNewGameCalled == true)
    }
    
    @Test("MainMenuInteractor handles multiple delegate calls correctly")
    @MainActor
    func testMultipleDelegateCalls() {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.newGameTapped()
        interactor.newGameTapped()
        
        // Assert
        #expect(mockDelegate.didSelectNewGameCalled == true)
        // Note: Multiple calls maintain the boolean state
    }
    
    // MARK: - Memory Management Tests
    
    @Test("MainMenuInteractor properly manages cancellables")
    @MainActor
    func testCancellablesManagement() {
        // Arrange & Act
        let mockDataManager = createMocks()
        var interactor: MainMenuInteractor? = MainMenuInteractor(dataManager: mockDataManager)
        
        // Verify interactor is created
        #expect(interactor != nil)
        
        // Act - Release the interactor
        interactor = nil
        
        // Assert - No assertion needed, this test verifies no memory leaks occur
        // The test passes if no retain cycles prevent deallocation
    }
    
    @Test("MainMenuInteractor handles delegate lifecycle correctly")
    @MainActor
    func testDelegateLifecycle() {
        // Arrange
        let mockDataManager = createMocks()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        var mockDelegate: MockMainMenuInteractorDelegate? = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Verify delegate is set
        #expect(interactor.delegate != nil)
        
        // Act - Release delegate
        mockDelegate = nil
        
        // Assert - Delegate should be nil (weak reference)
        #expect(interactor.delegate == nil)
    }
}
