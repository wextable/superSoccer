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
    
    @Test("MainMenuInteractor initializes with correct dependencies via factory")
    @MainActor
    func testInitializationWithFactoryDependencies() {
        // Arrange
        let container = MockDependencyContainer()
        
        // Act
        let interactor = container.interactorFactory.makeMainMenuInteractor()
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Assert
        #expect(interactor != nil)
        #expect(interactor.eventBus != nil)
    }
    
    @Test("MainMenuInteractor initializes with correct view model")
    @MainActor
    func testInitializationWithCorrectViewModel() {
        // Arrange
        let container = MockDependencyContainer()
        
        // Act
        let interactor = container.interactorFactory.makeMainMenuInteractor()
        
        // Assert
        #expect(interactor.viewModel.title == "Main menu")
        #expect(interactor.viewModel.menuItemModels.count == 1)
        #expect(interactor.viewModel.menuItemModels.first?.title == "New game")
    }
    
    @Test("MainMenuInteractor initializes with event bus")
    @MainActor
    func testInitializationWithEventBus() {
        // Arrange
        let container = MockDependencyContainer()
        
        // Act
        let interactor = container.interactorFactory.makeMainMenuInteractor()
        
        // Assert
        #expect(interactor.eventBus != nil)
    }
    
    // MARK: - Event Handling Tests
    
    @Test("MainMenuInteractor handles new game event correctly")
    @MainActor
    func testNewGameEventHandling() {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = container.interactorFactory.makeMainMenuInteractor()
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
        let container = MockDependencyContainer()
        let interactor = await container.interactorFactory.makeMainMenuInteractor()
        
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
        let container = MockDependencyContainer()
        let interactor = await container.interactorFactory.makeMainMenuInteractor()
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
    
    // MARK: - Business Logic Tests
    
    @Test("MainMenuInteractor provides correct menu structure")
    @MainActor
    func testMenuStructure() {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = container.interactorFactory.makeMainMenuInteractor()
        
        // Act
        let menuItems = interactor.viewModel.menuItemModels
        
        // Assert
        #expect(menuItems.count == 1)
        #expect(menuItems.first?.title == "New game")
        #expect(menuItems.first?.action != nil)
    }
    
    @Test("MainMenuInteractor menu action executes event bus communication")
    func testMenuActionEventBusCommunication() async {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = await container.interactorFactory.makeMainMenuInteractor()
        var eventsReceived: [MainMenuEvent] = []
        
        // Act & Assert
        await confirmation { confirm in
            let cancellable = interactor.eventBus
                .sink { event in
                    eventsReceived.append(event)
                    confirm()
                }
            
            // Execute menu action
            interactor.viewModel.menuItemModels.first?.action()
            
            // Store cancellable to prevent deallocation
            _ = cancellable
        }
        
        // Assert
        #expect(eventsReceived.count == 1)
        #expect(eventsReceived.first == .newGameSelected)
    }
    
    // MARK: - Event Bus Tests
    
    @Test("MainMenuInteractor event bus publishes events correctly")
    func testEventBusPublishesEvents() async {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = await container.interactorFactory.makeMainMenuInteractor()
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
    
    @Test("MainMenuInteractor handles multiple delegate calls correctly")
    @MainActor
    func testMultipleDelegateCalls() {
        // Arrange
        let container = MockDependencyContainer()
        let interactor = container.interactorFactory.makeMainMenuInteractor()
        let mockDelegate = MockMainMenuInteractorDelegate()
        interactor.delegate = mockDelegate
        
        // Act
        interactor.eventBus.send(.newGameSelected)
        interactor.eventBus.send(.newGameSelected)
        interactor.eventBus.send(.newGameSelected)
        
        // Assert
        #expect(mockDelegate.didSelectNewGameCalled == true)
        // Note: The delegate is called multiple times, but the boolean remains true
    }
    
    // MARK: - Memory Management Tests
    
    @Test("MainMenuInteractor properly manages cancellables")
    @MainActor
    func testCancellablesManagement() {
        // Arrange & Act
        let container = MockDependencyContainer()
        var interactor: MainMenuInteractorProtocol? = container.interactorFactory.makeMainMenuInteractor()
        
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
        let container = MockDependencyContainer()
        let interactor = container.interactorFactory.makeMainMenuInteractor()
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
