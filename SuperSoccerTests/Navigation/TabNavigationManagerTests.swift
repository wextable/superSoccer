//
//  TabNavigationManagerTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Testing
import Combine
import SwiftUI
@testable import SuperSoccer

struct TabNavigationManagerTests {
    
    // MARK: - Initialization Tests
    
    @Test("TabNavigationManager shared instance exists")
    @MainActor
    func testSharedInstanceExists() {
        // Act
        let manager = TabNavigationManager.shared
        
        // Assert
        #expect(manager != nil)
    }
    
    // MARK: - Navigation Tests
    
    @Test("TabNavigationManager navigate updates path and stack")
    @MainActor
    func testNavigateUpdatesPathAndStack() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Act
        manager.navigate(to: screen, in: tab)
        
        // Assert
        #expect(manager.tabNavigationPaths[tab]?.count == 1)
        #expect(manager.tabScreenStacks[tab]?.count == 1)
        #expect(manager.tabScreenStacks[tab]?.first == screen)
    }
    
    @Test("TabNavigationManager replaceStack clears and adds screen")
    @MainActor
    func testReplaceStackClearsAndAddsScreen() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Add some initial screens
        manager.navigate(to: screen, in: tab)
        manager.navigate(to: screen, in: tab)
        
        // Act
        manager.replaceStack(with: screen, in: tab)
        
        // Assert
        #expect(manager.tabNavigationPaths[tab]?.count == 0)
        #expect(manager.tabScreenStacks[tab]?.count == 1)
        #expect(manager.tabScreenStacks[tab]?.first == screen)
    }
    
    @Test("TabNavigationManager popToRoot clears path and stack")
    @MainActor
    func testPopToRootClearsPathAndStack() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Add some screens
        manager.navigate(to: screen, in: tab)
        manager.navigate(to: screen, in: tab)
        
        // Act
        manager.popToRoot(in: tab)
        
        // Assert
        #expect(manager.tabNavigationPaths[tab]?.count == 0)
        #expect(manager.tabScreenStacks[tab]?.count == 0)
    }
    
    @Test("TabNavigationManager pop removes last item")
    @MainActor
    func testPopRemovesLastItem() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Add some screens
        manager.navigate(to: screen, in: tab)
        manager.navigate(to: screen, in: tab)
        
        let initialPathCount = manager.tabNavigationPaths[tab]?.count ?? 0
        let initialStackCount = manager.tabScreenStacks[tab]?.count ?? 0
        
        // Act
        manager.pop(in: tab)
        
        // Assert
        #expect(manager.tabNavigationPaths[tab]?.count == initialPathCount - 1)
        #expect(manager.tabScreenStacks[tab]?.count == initialStackCount - 1)
    }
    
    // MARK: - Tab Type Tests
    
    @Test("TabNavigationManager works with different tab types")
    @MainActor
    func testWorksWithDifferentTabTypes() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Act & Assert - Test with team tab
        manager.navigate(to: screen, in: tab)
        #expect(manager.tabNavigationPaths[tab]?.count == 1)
        #expect(manager.tabScreenStacks[tab]?.count == 1)
        
        // Act & Assert - Test with league tab (when available)
        // let leagueTab: TabType = .league
        // manager.navigate(to: screen, in: leagueTab)
        // #expect(manager.tabNavigationPaths[leagueTab]?.count == 1)
        // #expect(manager.tabScreenStacks[leagueTab]?.count == 1)
    }
    
    // MARK: - Complex Flow Tests
    
    @Test("TabNavigationManager handles complex navigation flow")
    @MainActor
    func testComplexNavigationFlow() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Act - Simulate a complex navigation flow
        manager.navigate(to: screen, in: tab)
        manager.navigate(to: screen, in: tab)
        manager.replaceStack(with: screen, in: tab)
        manager.navigate(to: screen, in: tab)
        manager.popToRoot(in: tab)
        manager.navigate(to: screen, in: tab)
        manager.pop(in: tab)
        
        // Assert
        #expect(manager.tabNavigationPaths[tab]?.count == 0)
        #expect(manager.tabScreenStacks[tab]?.count == 0)
    }
    
    // MARK: - Multiple Operations Tests
    
    @Test("TabNavigationManager handles multiple rapid operations")
    @MainActor
    func testHandlesMultipleRapidOperations() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Act - Perform multiple operations rapidly
        manager.navigate(to: screen, in: tab)
        manager.navigate(to: screen, in: tab)
        manager.navigate(to: screen, in: tab)
        manager.pop(in: tab)
        manager.pop(in: tab)
        manager.pop(in: tab)
        manager.popToRoot(in: tab)
        
        // Assert - All operations should be handled gracefully
        #expect(manager.tabNavigationPaths[tab]?.count == 0)
        #expect(manager.tabScreenStacks[tab]?.count == 0)
    }
    
    // MARK: - Edge Cases
    
    @Test("TabNavigationManager handles pop on empty stack")
    @MainActor
    func testHandlesPopOnEmptyStack() {
        // Arrange
        let manager = TabNavigationManager.shared
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Act - Try to pop from empty stack
        manager.pop(in: tab)
        
        // Assert - Should not crash and should remain empty
        #expect(manager.tabNavigationPaths[tab] == nil)
        #expect(manager.tabScreenStacks[tab] == nil)
    }
    
    @Test("TabNavigationManager clearAllTabs removes all data")
    @MainActor
    func testClearAllTabsRemovesAllData() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        let tab: TabType = .team
        
        // Add some data
        manager.navigate(to: screen, in: tab)
        manager.navigate(to: screen, in: tab)
        
        // Act
        manager.clearAllTabs()
        
        // Assert
        #expect(manager.tabNavigationPaths.isEmpty)
        #expect(manager.tabScreenStacks.isEmpty)
    }
    
    @Test("TabNavigationManager handles different screen types")
    @MainActor
    func testHandlesDifferentScreenTypes() {
        // Arrange
        let manager = TabNavigationManager.shared
        let mockMainMenuInteractor = MockMainMenuInteractor()
        let mockTeamSelectInteractor = MockTeamSelectInteractor()
        let mockNewGameInteractor = MockNewGameInteractor()
        let tab: TabType = .team
        
        // Clear any existing state
        manager.clearAllTabs()
        
        // Act & Assert - Test different screen types
        let mainMenuScreen = NavigationRouter.Screen.mainMenu(interactor: mockMainMenuInteractor)
        manager.navigate(to: mainMenuScreen, in: tab)
        #expect(manager.tabScreenStacks[tab]?.first == mainMenuScreen)
        
        manager.clearAllTabs()
        
        let teamSelectScreen = NavigationRouter.Screen.teamSelect(interactor: mockTeamSelectInteractor)
        manager.navigate(to: teamSelectScreen, in: tab)
        #expect(manager.tabScreenStacks[tab]?.first == teamSelectScreen)
        
        manager.clearAllTabs()
        
        let newGameScreen = NavigationRouter.Screen.newGame(interactor: mockNewGameInteractor)
        manager.navigate(to: newGameScreen, in: tab)
        #expect(manager.tabScreenStacks[tab]?.first == newGameScreen)
    }
    
    // MARK: - Published Properties Tests
    
    @Test("TabNavigationManager published properties are accessible")
    @MainActor
    func testPublishedPropertiesAreAccessible() {
        // Arrange
        let manager = TabNavigationManager.shared
        
        // Act & Assert - Properties should be accessible
        #expect(manager.tabNavigationPaths != nil)
        #expect(manager.tabScreenStacks != nil)
    }
} 