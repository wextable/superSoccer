//
//  NavigationRouterTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Testing
import SwiftUI
import Combine
@testable import SuperSoccer

struct NavigationRouterTests {
    
    // MARK: - Initialization Tests
    
    @Test("NavigationRouter initializes with empty state")
    @MainActor
    func testInitializationWithEmptyState() {
        // Arrange & Act
        let router = NavigationRouter()
        
        // Assert
        #expect(router.path.isEmpty)
        #expect(router.screens.isEmpty)
        #expect(router.presentedSheet == nil)
    }
    
    // MARK: - Navigation Tests
    
    @Test("NavigationRouter navigate adds screen to path and screens")
    @MainActor
    func testNavigateAddsScreenToPathAndScreens() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Act
        router.navigate(to: screen)
        
        // Assert
        #expect(router.path.count == 1)
        #expect(router.screens.count == 1)
        #expect(router.screens.first == screen)
    }
    
    @Test("NavigationRouter navigate adds multiple screens")
    @MainActor
    func testNavigateAddsMultipleScreens() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor1 = MockMainMenuInteractor()
        let mockInteractor2 = MockNewGameInteractor()
        let screen1 = NavigationRouter.Screen.mainMenu(presenter: mockInteractor1)
        let screen2 = NavigationRouter.Screen.newGame(presenter: mockInteractor2)
        
        // Act
        router.navigate(to: screen1)
        router.navigate(to: screen2)
        
        // Assert
        #expect(router.path.count == 2)
        #expect(router.screens.count == 2)
        #expect(router.screens[0] == screen1)
        #expect(router.screens[1] == screen2)
    }
    
    // MARK: - Replace Navigation Stack Tests
    
    @Test("NavigationRouter replaceNavigationStack with root screen clears path")
    @MainActor
    func testReplaceNavigationStackWithRootScreenClearsPath() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Add some screens first
        router.navigate(to: screen)
        router.navigate(to: screen)
        
        // Act
        router.replaceNavigationStack(with: screen)
        
        // Assert
        #expect(router.path.isEmpty)
        #expect(router.screens.count == 1)
        #expect(router.screens.first == screen)
    }
    
    @Test("NavigationRouter replaceNavigationStack with splash clears path")
    @MainActor
    func testReplaceNavigationStackWithSplashClearsPath() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockMainMenuInteractor()
        let mainMenuScreen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        let splashScreen = NavigationRouter.Screen.splash
        
        // Add some screens first
        router.navigate(to: mainMenuScreen)
        router.navigate(to: mainMenuScreen)
        
        // Act
        router.replaceNavigationStack(with: splashScreen)
        
        // Assert
        #expect(router.path.isEmpty)
        #expect(router.screens.count == 1)
        #expect(router.screens.first == splashScreen)
    }
    
    @Test("NavigationRouter replaceNavigationStack with non-root screen sets path")
    @MainActor
    func testReplaceNavigationStackWithNonRootScreenSetsPath() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockNewGameInteractor()
        let screen = NavigationRouter.Screen.newGame(presenter: mockInteractor)
        
        // Act
        router.replaceNavigationStack(with: screen)
        
        // Assert
        #expect(router.path.count == 1)
        #expect(router.screens.count == 1)
        #expect(router.screens.first == screen)
    }
    
    @Test("NavigationRouter replaceNavigationStack with team screen sets path")
    @MainActor
    func testReplaceNavigationStackWithTeamScreenSetsPath() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockTeamInteractor()
        let screen = NavigationRouter.Screen.team(interactor: mockInteractor)
        
        // Act
        router.replaceNavigationStack(with: screen)
        
        // Assert
        #expect(router.path.count == 1)
        #expect(router.screens.count == 1)
        #expect(router.screens.first == screen)
    }
    
    @Test("NavigationRouter replaceNavigationStack with tabContainer sets path")
    @MainActor
    func testReplaceNavigationStackWithTabContainerSetsPath() {
        // Arrange
        let router = NavigationRouter()
        let screen = NavigationRouter.Screen.tabContainer(tabs: [])
        
        // Act
        router.replaceNavigationStack(with: screen)
        
        // Assert
        #expect(router.path.count == 1)
        #expect(router.screens.count == 1)
        #expect(router.screens.first == screen)
    }
    
    // MARK: - Pop Tests
    
    @Test("NavigationRouter pop removes last screen from path and screens")
    @MainActor
    func testPopRemovesLastScreenFromPathAndScreens() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor1 = MockMainMenuInteractor()
        let mockInteractor2 = MockNewGameInteractor()
        let screen1 = NavigationRouter.Screen.mainMenu(presenter: mockInteractor1)
        let screen2 = NavigationRouter.Screen.newGame(presenter: mockInteractor2)
        
        router.navigate(to: screen1)
        router.navigate(to: screen2)
        let initialPathCount = router.path.count
        let initialScreensCount = router.screens.count
        
        // Act
        router.pop()
        
        // Assert
        #expect(router.path.count == initialPathCount - 1)
        #expect(router.screens.count == initialScreensCount - 1)
        #expect(router.screens.last == screen1)
    }
    
    @Test("NavigationRouter pop handles empty path gracefully")
    @MainActor
    func testPopHandlesEmptyPathGracefully() {
        // Arrange
        let router = NavigationRouter()
        
        // Act - Try to pop from empty path
        router.pop()
        
        // Assert - Should not crash and should remain empty
        #expect(router.path.isEmpty)
        #expect(router.screens.isEmpty)
    }
    
    @Test("NavigationRouter pop handles single screen")
    @MainActor
    func testPopHandlesSingleScreen() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        router.navigate(to: screen)
        
        // Act
        router.pop()
        
        // Assert
        #expect(router.path.isEmpty)
        #expect(router.screens.isEmpty)
    }
    
    // MARK: - Pop To Root Tests
    
    @Test("NavigationRouter popToRoot clears path and screens")
    @MainActor
    func testPopToRootClearsPathAndScreens() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor1 = MockMainMenuInteractor()
        let mockInteractor2 = MockNewGameInteractor()
        let screen1 = NavigationRouter.Screen.mainMenu(presenter: mockInteractor1)
        let screen2 = NavigationRouter.Screen.newGame(presenter: mockInteractor2)
        
        router.navigate(to: screen1)
        router.navigate(to: screen2)
        
        // Act
        router.popToRoot()
        
        // Assert
        #expect(router.path.isEmpty)
        #expect(router.screens.isEmpty)
    }
    
    @Test("NavigationRouter popToRoot handles empty state")
    @MainActor
    func testPopToRootHandlesEmptyState() {
        // Arrange
        let router = NavigationRouter()
        
        // Act
        router.popToRoot()
        
        // Assert
        #expect(router.path.isEmpty)
        #expect(router.screens.isEmpty)
    }
    
    // MARK: - Sheet Tests
    
    @Test("NavigationRouter dismissSheet clears presentedSheet")
    @MainActor
    func testDismissSheetClearsPresentedSheet() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockTeamSelectInteractor()
        let screen = NavigationRouter.Screen.teamSelect(interactor: mockInteractor)
        
        router.presentedSheet = screen
        
        // Act
        router.dismissSheet()
        
        // Assert
        #expect(router.presentedSheet == nil)
    }
    
    @Test("NavigationRouter dismissSheet handles nil presentedSheet")
    @MainActor
    func testDismissSheetHandlesNilPresentedSheet() {
        // Arrange
        let router = NavigationRouter()
        
        // Act - Try to dismiss when no sheet is presented
        router.dismissSheet()
        
        // Assert - Should not crash and should remain nil
        #expect(router.presentedSheet == nil)
    }
    
    // MARK: - Screen Type Tests
    
    @Test("NavigationRouter handles all screen types")
    @MainActor
    func testHandlesAllScreenTypes() {
        // Arrange
        let router = NavigationRouter()
        let mockMainMenuInteractor = MockMainMenuInteractor()
        let mockNewGameInteractor = MockNewGameInteractor()
        let mockTeamSelectInteractor = MockTeamSelectInteractor()
        let mockTeamInteractor = MockTeamInteractor()
        
        let splashScreen = NavigationRouter.Screen.splash
        let mainMenuScreen = NavigationRouter.Screen.mainMenu(presenter: mockMainMenuInteractor)
        let newGameScreen = NavigationRouter.Screen.newGame(presenter: mockNewGameInteractor)
        let teamSelectScreen = NavigationRouter.Screen.teamSelect(interactor: mockTeamSelectInteractor)
        let teamScreen = NavigationRouter.Screen.team(interactor: mockTeamInteractor)
        let tabContainerScreen = NavigationRouter.Screen.tabContainer(tabs: [])
        
        // Act & Assert - Test each screen type
        router.navigate(to: splashScreen)
        #expect(router.path.count == 1)
        #expect(router.screens.count == 1)
        #expect(router.screens.first == splashScreen)
        
        router.navigate(to: mainMenuScreen)
        #expect(router.path.count == 2)
        #expect(router.screens.count == 2)
        #expect(router.screens.last == mainMenuScreen)
        
        router.navigate(to: newGameScreen)
        #expect(router.path.count == 3)
        #expect(router.screens.count == 3)
        #expect(router.screens.last == newGameScreen)
        
        router.navigate(to: teamSelectScreen)
        #expect(router.path.count == 4)
        #expect(router.screens.count == 4)
        #expect(router.screens.last == teamSelectScreen)
        
        router.navigate(to: teamScreen)
        #expect(router.path.count == 5)
        #expect(router.screens.count == 5)
        #expect(router.screens.last == teamScreen)
        
        router.navigate(to: tabContainerScreen)
        #expect(router.path.count == 6)
        #expect(router.screens.count == 6)
        #expect(router.screens.last == tabContainerScreen)
    }
    
    // MARK: - Screen Equality Tests
    
    @Test("NavigationRouter Screen equality works correctly")
    @MainActor
    func testScreenEqualityWorksCorrectly() {
        // Arrange
        let mockInteractor1 = MockMainMenuInteractor()
        let mockInteractor2 = MockMainMenuInteractor()
        let screen1 = NavigationRouter.Screen.mainMenu(presenter: mockInteractor1)
        let screen2 = NavigationRouter.Screen.mainMenu(presenter: mockInteractor2)
        let screen3 = NavigationRouter.Screen.splash
        
        // Act & Assert
        #expect(screen1 == screen2) // Same type, different interactors
        #expect(screen1 != screen3) // Different types
        #expect(screen1 == screen1) // Same instance
    }
    
    @Test("NavigationRouter Screen hash works correctly")
    @MainActor
    func testScreenHashWorksCorrectly() {
        // Arrange
        let mockInteractor1 = MockMainMenuInteractor()
        let mockInteractor2 = MockMainMenuInteractor()
        let screen1 = NavigationRouter.Screen.mainMenu(presenter: mockInteractor1)
        let screen2 = NavigationRouter.Screen.mainMenu(presenter: mockInteractor2)
        
        // Act & Assert
        #expect(screen1.hashValue != 0)
        #expect(screen2.hashValue != 0)
        // Different interactors should have different hash values
        #expect(screen1.hashValue != screen2.hashValue)
    }
    
    // MARK: - Complex Navigation Flow Tests
    
    @Test("NavigationRouter handles complex navigation flow")
    @MainActor
    func testComplexNavigationFlow() {
        // Arrange
        let router = NavigationRouter()
        let mockMainMenuInteractor = MockMainMenuInteractor()
        let mockNewGameInteractor = MockNewGameInteractor()
        let mockTeamSelectInteractor = MockTeamSelectInteractor()
        
        let mainMenuScreen = NavigationRouter.Screen.mainMenu(presenter: mockMainMenuInteractor)
        let newGameScreen = NavigationRouter.Screen.newGame(presenter: mockNewGameInteractor)
        let teamSelectScreen = NavigationRouter.Screen.teamSelect(interactor: mockTeamSelectInteractor)
        
        // Act - Simulate a complex navigation flow
        router.replaceNavigationStack(with: mainMenuScreen)
        router.navigate(to: newGameScreen)
        router.presentedSheet = teamSelectScreen
        router.dismissSheet()
        router.pop()
        
        // Assert
        #expect(router.screens.count == 1) // Only mainMenu should remain
        #expect(router.screens.first == mainMenuScreen)
        #expect(router.path.isEmpty) // mainMenu is a root screen, so path is empty
        #expect(router.presentedSheet == nil)
    }
    
    @Test("NavigationRouter handles rapid navigation operations")
    @MainActor
    func testRapidNavigationOperations() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Act - Make rapid navigation calls
        for _ in 0..<10 {
            router.navigate(to: screen)
        }
        
        // Assert
        #expect(router.path.count == 10)
        #expect(router.screens.count == 10)
    }
    
    @Test("NavigationRouter handles rapid pop operations")
    @MainActor
    func testRapidPopOperations() {
        // Arrange
        let router = NavigationRouter()
        let mockInteractor = MockMainMenuInteractor()
        let screen = NavigationRouter.Screen.mainMenu(presenter: mockInteractor)
        
        // Add some screens
        for _ in 0..<5 {
            router.navigate(to: screen)
        }
        
        // Act - Make rapid pop calls
        for _ in 0..<10 {
            router.pop()
        }
        
        // Assert - Should not go below empty
        #expect(router.path.isEmpty)
        #expect(router.screens.isEmpty)
    }
    
    // MARK: - Edge Case Tests
    
    @Test("NavigationRouter handles mixed root and non-root screens")
    @MainActor
    func testHandlesMixedRootAndNonRootScreens() {
        // Arrange
        let router = NavigationRouter()
        let mockMainMenuInteractor = MockMainMenuInteractor()
        let mockNewGameInteractor = MockNewGameInteractor()
        
        let mainMenuScreen = NavigationRouter.Screen.mainMenu(presenter: mockMainMenuInteractor)
        let newGameScreen = NavigationRouter.Screen.newGame(presenter: mockNewGameInteractor)
        
        // Act - Test root screen replacement
        router.navigate(to: newGameScreen)
        router.navigate(to: newGameScreen)
        router.replaceNavigationStack(with: mainMenuScreen)
        
        // Assert
        #expect(router.path.isEmpty) // Root screen clears path
        #expect(router.screens.count == 1)
        #expect(router.screens.first == mainMenuScreen)
        
        // Act - Test non-root screen replacement
        router.replaceNavigationStack(with: newGameScreen)
        
        // Assert
        #expect(router.path.count == 1) // Non-root screen sets path
        #expect(router.screens.count == 1)
        #expect(router.screens.first == newGameScreen)
    }
    
    @Test("NavigationRouter handles tabContainer with different tab configurations")
    @MainActor
    func testHandlesTabContainerWithDifferentTabConfigurations() {
        // Implement this after we actually have multiple tabs
//        // Arrange
//        let router = NavigationRouter()
//        let tabs1 = [TabConfiguration(type: .team, title: "Team", iconName: "person.3")]
//        let tabs2 = [TabConfiguration(type: .league, title: "League", iconName: "trophy")]
//        
//        let screen1 = NavigationRouter.Screen.tabContainer(tabs: tabs1)
//        let screen2 = NavigationRouter.Screen.tabContainer(tabs: tabs2)
//        
//        // Act
//        router.navigate(to: screen1)
//        router.navigate(to: screen2)
//        
//        // Assert
//        #expect(router.path.count == 2)
//        #expect(router.screens.count == 2)
//        #expect(router.screens[0] == screen1)
//        #expect(router.screens[1] == screen2)
    }
}
