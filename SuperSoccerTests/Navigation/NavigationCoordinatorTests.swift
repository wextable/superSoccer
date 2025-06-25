//
//  NavigationCoordinatorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Testing
import Combine
@testable import SuperSoccer

struct NavigationCoordinatorTests {
    
    // MARK: - Initialization Tests
    
    @Test("NavigationCoordinator initializes with router")
    @MainActor
    func testInitializationWithRouter() {
        // Arrange
        let router = NavigationRouter()
        
        // Act
        let coordinator = NavigationCoordinator(router: router)
        
        // Assert
        #expect(coordinator != nil)
    }
    
    // MARK: - Navigation Tests
    
    @Test("NavigationCoordinator navigateToScreen calls router navigate")
    @MainActor
    func testNavigateToScreenCallsRouterNavigate() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        
        // Act
        coordinator.navigateToScreen(screen)
        
        // Assert
        #expect(router.screens.count == 1)
        #expect(router.screens.first == screen)
        #expect(router.path.count == 1)
    }
    
    @Test("NavigationCoordinator replaceStackWith calls router replaceNavigationStack")
    @MainActor
    func testReplaceStackWithCallsRouterReplaceNavigationStack() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        
        // Act
        coordinator.replaceStackWith(screen)
        
        // Assert
        #expect(router.screens.count == 1)
        #expect(router.screens.first == screen)
        #expect(router.path.isEmpty) // Root screens clear the path
    }
    
    @Test("NavigationCoordinator replaceStackWith handles non-root screens")
    @MainActor
    func testReplaceStackWithHandlesNonRootScreens() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockNewGameInteractor()
        let screen = NavigationRouter.Screen.newGame(presenter: mockInteractor)
        
        // Act
        coordinator.replaceStackWith(screen)
        
        // Assert
        #expect(router.screens.count == 1)
        #expect(router.screens.first == screen)
        #expect(router.path.count == 1) // Non-root screens stay in path
    }
    
    @Test("NavigationCoordinator popToRoot calls router popToRoot")
    @MainActor
    func testPopToRootCallsRouterPopToRoot() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        
        // Add some screens first
        coordinator.navigateToScreen(screen)
        coordinator.navigateToScreen(screen)
        
        // Act
        coordinator.popToRoot()
        
        // Assert
        #expect(router.path.isEmpty)
        #expect(router.screens.isEmpty)
    }
    
    @Test("NavigationCoordinator popScreen calls router pop")
    @MainActor
    func testPopScreenCallsRouterPop() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        
        // Add some screens first
        coordinator.navigateToScreen(screen)
        coordinator.navigateToScreen(screen)
        let initialCount = router.screens.count
        
        // Act
        coordinator.popScreen()
        
        // Assert
        #expect(router.screens.count == initialCount - 1)
        #expect(router.path.count == initialCount - 1)
    }
    
    @Test("NavigationCoordinator popScreen handles empty stack")
    @MainActor
    func testPopScreenHandlesEmptyStack() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        
        // Act - Try to pop from empty stack
        coordinator.popScreen()
        
        // Assert - Should not crash and should remain empty
        #expect(router.screens.isEmpty)
        #expect(router.path.isEmpty)
    }
    
    @Test("NavigationCoordinator presentSheet sets router presentedSheet")
    @MainActor
    func testPresentSheetSetsRouterPresentedSheet() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockTeamSelectInteractor()
        let screen = NavigationRouter.Screen.teamSelect(interactor: mockInteractor)
        
        // Act
        coordinator.presentSheet(screen)
        
        // Assert
        #expect(router.presentedSheet == screen)
    }
    
    @Test("NavigationCoordinator dismissSheet clears router presentedSheet")
    @MainActor
    func testDismissSheetClearsRouterPresentedSheet() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockTeamSelectInteractor()
        let screen = NavigationRouter.Screen.teamSelect(interactor: mockInteractor)
        
        // Set up a presented sheet
        coordinator.presentSheet(screen)
        #expect(router.presentedSheet == screen)
        
        // Act
        coordinator.dismissSheet()
        
        // Assert
        #expect(router.presentedSheet == nil)
    }
    
    // MARK: - Complex Navigation Flow Tests
    
    @Test("NavigationCoordinator handles complex navigation flow")
    @MainActor
    func testComplexNavigationFlow() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockMainMenuInteractor = MockMainMenuInteractor()
        let mockNewGameInteractor = MockNewGameInteractor()
        let mockTeamSelectInteractor = MockTeamSelectInteractor()
        
        let mainMenuScreen = NavigationRouter.Screen.mainMenu(interactor: mockMainMenuInteractor)
        let newGameScreen = NavigationRouter.Screen.newGame(presenter: mockNewGameInteractor)
        let teamSelectScreen = NavigationRouter.Screen.teamSelect(interactor: mockTeamSelectInteractor)
        
        // Act - Simulate a complex navigation flow
        coordinator.replaceStackWith(mainMenuScreen)
        coordinator.navigateToScreen(newGameScreen)
        coordinator.presentSheet(teamSelectScreen)
        coordinator.dismissSheet()
        coordinator.popScreen()
        
        // Assert
        #expect(router.screens.count == 1) // Only mainMenu should remain
        #expect(router.screens.first == mainMenuScreen)
        #expect(router.path.count == 0) // mainMenu is a root screen, so path is empty
        #expect(router.presentedSheet == nil)
    }
    
    // MARK: - Screen Type Tests
    
    @Test("NavigationCoordinator handles all screen types")
    @MainActor
    func testHandlesAllScreenTypes() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockMainMenuInteractor = MockMainMenuInteractor()
        let mockNewGameInteractor = MockNewGameInteractor()
        let mockTeamSelectInteractor = MockTeamSelectInteractor()
        let mockTeamInteractor = MockTeamInteractor()
        
        let splashScreen = NavigationRouter.Screen.splash
        let mainMenuScreen = NavigationRouter.Screen.mainMenu(interactor: mockMainMenuInteractor)
        let newGameScreen = NavigationRouter.Screen.newGame(presenter: mockNewGameInteractor)
        let teamSelectScreen = NavigationRouter.Screen.teamSelect(interactor: mockTeamSelectInteractor)
        let teamScreen = NavigationRouter.Screen.team(interactor: mockTeamInteractor)
        let tabContainerScreen = NavigationRouter.Screen.tabContainer(tabs: [])
        
        // Act & Assert - Test each screen type
        coordinator.navigateToScreen(splashScreen)
        #expect(router.screens.count == 1)
        #expect(router.screens.first == splashScreen)
        
        coordinator.navigateToScreen(mainMenuScreen)
        #expect(router.screens.count == 2)
        #expect(router.screens.last == mainMenuScreen)
        
        coordinator.navigateToScreen(newGameScreen)
        #expect(router.screens.count == 3)
        #expect(router.screens.last == newGameScreen)
        
        coordinator.navigateToScreen(teamSelectScreen)
        #expect(router.screens.count == 4)
        #expect(router.screens.last == teamSelectScreen)
        
        coordinator.navigateToScreen(teamScreen)
        #expect(router.screens.count == 5)
        #expect(router.screens.last == teamScreen)
        
        coordinator.navigateToScreen(tabContainerScreen)
        #expect(router.screens.count == 6)
        #expect(router.screens.last == tabContainerScreen)
    }
    
    // MARK: - Edge Case Tests
    
    @Test("NavigationCoordinator handles rapid navigation calls")
    @MainActor
    func testRapidNavigationCalls() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        
        // Act - Make rapid navigation calls
        for _ in 0..<10 {
            coordinator.navigateToScreen(screen)
        }
        
        // Assert
        #expect(router.screens.count == 10)
        #expect(router.path.count == 10)
    }
    
    @Test("NavigationCoordinator handles rapid pop calls")
    @MainActor
    func testRapidPopCalls() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(interactor: mockInteractor)
        
        // Add some screens
        for _ in 0..<5 {
            coordinator.navigateToScreen(screen)
        }
        
        // Act - Make rapid pop calls
        for _ in 0..<10 {
            coordinator.popScreen()
        }
        
        // Assert - Should not go below empty
        #expect(router.screens.isEmpty)
        #expect(router.path.isEmpty)
    }
    
    @Test("NavigationCoordinator handles rapid sheet operations")
    @MainActor
    func testRapidSheetOperations() {
        // Arrange
        let router = NavigationRouter()
        let coordinator = NavigationCoordinator(router: router)
        let mockInteractor = MockTeamSelectInteractor()
        let screen = NavigationRouter.Screen.teamSelect(interactor: mockInteractor)
        
        // Act - Rapid sheet operations
        coordinator.presentSheet(screen)
        coordinator.dismissSheet()
        coordinator.presentSheet(screen)
        coordinator.dismissSheet()
        coordinator.presentSheet(screen)
        
        // Assert
        #expect(router.presentedSheet == screen)
    }
}
