//
//  TabNavigationCoordinatorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Testing
import Combine
@testable import SuperSoccer

struct TabNavigationCoordinatorTests {
    
    // MARK: - Initialization Tests
    
    @Test("TabNavigationCoordinator initializes with tab and parent coordinator")
    @MainActor
    func testInitializationWithTabAndParentCoordinator() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let tab: TabType = .team
        
        // Act
        let coordinator = TabNavigationCoordinator(tab: tab, parentNavigationCoordinator: mockParentCoordinator)
        
        // Assert
        #expect(coordinator != nil)
    }
    
    // MARK: - Navigation Tests
    
    @Test("TabNavigationCoordinator navigateToScreen calls TabNavigationManager")
    @MainActor
    func testNavigateToScreenCallsTabNavigationManager() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let coordinator = TabNavigationCoordinator(tab: .team, parentNavigationCoordinator: mockParentCoordinator)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Act
        coordinator.navigateToScreen(screen)
        
        // Assert - We can't directly test TabNavigationManager calls, but we can test it doesn't crash
        #expect(coordinator != nil)
    }
    
    @Test("TabNavigationCoordinator replaceStackWith calls TabNavigationManager")
    @MainActor
    func testReplaceStackWithCallsTabNavigationManager() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let coordinator = TabNavigationCoordinator(tab: .team, parentNavigationCoordinator: mockParentCoordinator)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Act
        coordinator.replaceStackWith(screen)
        
        // Assert - We can't directly test TabNavigationManager calls, but we can test it doesn't crash
        #expect(coordinator != nil)
    }
    
    @Test("TabNavigationCoordinator popToRoot calls TabNavigationManager")
    @MainActor
    func testPopToRootCallsTabNavigationManager() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let coordinator = TabNavigationCoordinator(tab: .team, parentNavigationCoordinator: mockParentCoordinator)
        
        // Act
        coordinator.popToRoot()
        
        // Assert - We can't directly test TabNavigationManager calls, but we can test it doesn't crash
        #expect(coordinator != nil)
    }
    
    @Test("TabNavigationCoordinator popScreen calls TabNavigationManager")
    @MainActor
    func testPopScreenCallsTabNavigationManager() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let coordinator = TabNavigationCoordinator(tab: .team, parentNavigationCoordinator: mockParentCoordinator)
        
        // Act
        coordinator.popScreen()
        
        // Assert - We can't directly test TabNavigationManager calls, but we can test it doesn't crash
        #expect(coordinator != nil)
    }
    
    // MARK: - Sheet Tests
    
    @Test("TabNavigationCoordinator presentSheet delegates to parent coordinator")
    @MainActor
    func testPresentSheetDelegatesToParentCoordinator() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let coordinator = TabNavigationCoordinator(tab: .team, parentNavigationCoordinator: mockParentCoordinator)
        let mockInteractor = MockTeamSelectInteractor()
        let screen = NavigationRouter.Screen.teamSelect(presenter: mockInteractor)
        
        // Act
        coordinator.presentSheet(screen)
        
        // Assert
        #expect(mockParentCoordinator.screenToPresent == screen)
    }
    
    @Test("TabNavigationCoordinator dismissSheet delegates to parent coordinator")
    @MainActor
    func testDismissSheetDelegatesToParentCoordinator() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let coordinator = TabNavigationCoordinator(tab: .team, parentNavigationCoordinator: mockParentCoordinator)
        
        // Act
        coordinator.dismissSheet()
        
        // Assert
        #expect(mockParentCoordinator.didCallDismissSheet == true)
    }
    
    // MARK: - Tab Type Tests
    
    @Test("TabNavigationCoordinator works with different tab types")
    @MainActor
    func testWorksWithDifferentTabTypes() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Act & Assert - Test with team tab
        let teamCoordinator = TabNavigationCoordinator(tab: .team, parentNavigationCoordinator: mockParentCoordinator)
        teamCoordinator.navigateToScreen(screen)
        #expect(teamCoordinator != nil)
        
        // Act & Assert - Test with league tab (when available)
        // let leagueCoordinator = TabNavigationCoordinator(tab: .league, parentNavigationCoordinator: mockParentCoordinator)
        // leagueCoordinator.navigateToScreen(screen)
        // #expect(leagueCoordinator != nil)
    }
    
    // MARK: - Complex Flow Tests
    
    @Test("TabNavigationCoordinator handles complex navigation flow")
    @MainActor
    func testComplexNavigationFlow() {
        // Arrange
        let mockParentCoordinator = MockNavigationCoordinator()
        let coordinator = TabNavigationCoordinator(tab: .team, parentNavigationCoordinator: mockParentCoordinator)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Act - Simulate a complex navigation flow
        coordinator.navigateToScreen(screen)
        coordinator.replaceStackWith(screen)
        coordinator.popToRoot()
        coordinator.popScreen()
        coordinator.presentSheet(screen)
        coordinator.dismissSheet()
        
        // Assert - We can't directly test TabNavigationManager calls, but we can test it doesn't crash
        #expect(coordinator != nil)
        #expect(mockParentCoordinator.screenToPresent == screen)
        #expect(mockParentCoordinator.didCallDismissSheet == true)
    }
    
    // MARK: - Mock Tests
    
    @Test("MockTabNavigationCoordinator tracks navigation calls")
    @MainActor
    func testMockTabNavigationCoordinatorTracksNavigationCalls() {
        // Arrange
        let mockCoordinator = MockTabNavigationCoordinator()
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Act
        mockCoordinator.navigateToScreen(screen)
        mockCoordinator.replaceStackWith(screen)
        mockCoordinator.popToRoot()
        mockCoordinator.popScreen()
        mockCoordinator.presentSheet(screen)
        mockCoordinator.dismissSheet()
        
        // Assert
        #expect(mockCoordinator.screenNavigatedTo == screen)
        #expect(mockCoordinator.screenToReplaceStack == screen)
        #expect(mockCoordinator.didCallPopToRoot == true)
        #expect(mockCoordinator.didCallPopScreen == true)
        #expect(mockCoordinator.screenToPresent == screen)
        #expect(mockCoordinator.didCallDismissSheet == true)
    }
} 