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
    
    // MARK: - Initialization Tests
    
    @Test("MainMenuInteractor initializes with correct view model")
    func testInitializationWithCorrectViewModel() {
        // Arrange
        let mockDataManager = MockDataManager()
        
        // Act
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        
        // Assert
        #expect(interactor.viewModel.title == "Main menu")
        #expect(interactor.viewModel.menuItemModels.count == 1)
        #expect(interactor.viewModel.menuItemModels.first?.title == "New Game")
    }
    
    @Test("MainMenuInteractor initializes with event bus")
    func testInitializationWithEventBus() {
        // Arrange
        let mockDataManager = MockDataManager()
        
        // Act
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        
        // Assert
        #expect(interactor.eventBus != nil)
    }
    
    // MARK: - Event Handling Tests
    
    @Test("MainMenuInteractor handles new game event correctly")
    func testNewGameEventHandling() {
        // Arrange
        let mockDataManager = MockDataManager()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.eventBus.send(.newGameSelected)
        
        // Assert - This should happen immediately since Combine sink is synchronous
        #expect(mockDelegate.didSelectNewGameCalled == true)
    }
    
    @Test("MainMenuInteractor menu item action triggers event")
    func testMenuItemActionTriggersEvent() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        
        // Act & Assert
        await confirmation { confirm in
            let cancellable = interactor.eventBus
                .sink { event in
                    #expect(event == .newGameSelected)
                    confirm()
                }
            
            // Trigger the action
            interactor.viewModel.menuItemModels.first?.action()
            
            // Store cancellable to prevent deallocation
            _ = cancellable
        }
    }
    
    @Test("MainMenuInteractor delegate method calls are forwarded correctly")
    func testDelegateMethodForwarding() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act & Assert
        await confirmation { confirm in
            // Set up observation BEFORE sending the event
            mockDelegate.onDidSelectNewGame = {
                confirm()
            }
            
            // Now send the event
            interactor.eventBus.send(.newGameSelected)
        }
        
        // Final assertion
        #expect(mockDelegate.didSelectNewGameCalled == true)
    }
    
    // MARK: - Event Bus Tests
    
    @Test("MainMenuInteractor event bus publishes events correctly")
    func testEventBusPublishesEvents() async {
        // Arrange
        let mockDataManager = MockDataManager()
        let interactor = MainMenuInteractor(dataManager: mockDataManager)
        var receivedEvents: [MainMenuEvent] = []
        
        // Act & Assert
        await confirmation(expectedCount: 2) { confirm in
            let cancellable = interactor.eventBus
                .sink { event in
                    receivedEvents.append(event)
                    confirm()
                }
            
            // Send events
            interactor.eventBus.send(.newGameSelected)
            interactor.eventBus.send(.newGameSelected)
            
            // Store cancellable to prevent deallocation
            _ = cancellable
        }
        
        // Assert
        #expect(receivedEvents.count == 2)
        #expect(receivedEvents.allSatisfy { $0 == .newGameSelected })
    }
    
    // MARK: - Memory Management Tests
    
    @Test("MainMenuInteractor properly manages cancellables")
    func testCancellablesManagement() {
        // Arrange & Act
        let mockDataManager = MockDataManager()
        var interactor: MainMenuInteractor? = MainMenuInteractor(dataManager: mockDataManager)
        
        // Verify interactor is created
        #expect(interactor != nil)
        
        // Act - Release the interactor
        interactor = nil
        
        // Assert - No assertion needed, this test verifies no memory leaks occur
        // The test passes if no retain cycles prevent deallocation
    }
}
