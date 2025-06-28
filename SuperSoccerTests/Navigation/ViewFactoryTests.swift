//
//  ViewFactoryTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Testing
import SwiftUI
@testable import SuperSoccer

struct ViewFactoryTests {
    
    // MARK: - Initialization Tests
    
    @Test("ViewFactory initializes successfully")
    @MainActor
    func testInitialization() {
        // Act
        let factory = ViewFactory()
        
        // Assert
        #expect(factory != nil)
    }
    
    // MARK: - Screen Type Tests
    
    @Test("ViewFactory creates splash view")
    @MainActor
    func testCreatesSplashView() {
        // Arrange
        let factory = ViewFactory()
        
        // Act
        let view = factory.makeView(for: .splash)
        
        // Assert
        #expect(view != nil)
    }
    
    @Test("ViewFactory creates main menu view")
    @MainActor
    func testCreatesMainMenuView() {
        // Arrange
        let factory = ViewFactory()
        let mockInteractor = MockMainMenuInteractor()
        
        // Act
        let view = factory.makeView(for: .mainMenu(presenter: mockInteractor))
        
        // Assert
        #expect(view != nil)
    }
    
    @Test("ViewFactory creates new game view")
    @MainActor
    func testCreatesNewGameView() {
        // Arrange
        let factory = ViewFactory()
        let mockInteractor = MockNewGameInteractor()
        
        // Act
        let view = factory.makeView(for: .newGame(presenter: mockInteractor))
        
        // Assert
        #expect(view != nil)
    }
    
    @Test("ViewFactory creates team select view")
    @MainActor
    func testCreatesTeamSelectView() {
        // Arrange
        let factory = ViewFactory()
        let mockInteractor = MockTeamSelectInteractor()
        
        // Act
        let view = factory.makeView(for: .teamSelect(presenter: mockInteractor))
        
        // Assert
        #expect(view != nil)
    }
    
    @Test("ViewFactory creates team view")
    @MainActor
    func testCreatesTeamView() {
        // Arrange
        let factory = ViewFactory()
        let mockInteractor = MockTeamInteractor()
        
        // Act
        let view = factory.makeView(for: .team(presenter: mockInteractor))
        
        // Assert
        #expect(view != nil)
    }
    
    @Test("ViewFactory creates tab container view")
    @MainActor
    func testCreatesTabContainerView() {
        // Arrange
        let factory = ViewFactory()
        let tabs: [TabConfiguration] = [
            TabConfiguration(type: .team, title: "Team", iconName: "person.3")
        ]
        
        // Act
        let view = factory.makeView(for: .tabContainer(tabs: tabs))
        
        // Assert
        #expect(view != nil)
    }
    
    // MARK: - Multiple Screen Creation Tests
    
    @Test("ViewFactory can create multiple views of different types")
    @MainActor
    func testCanCreateMultipleViewsOfDifferentTypes() {
        // Arrange
        let factory = ViewFactory()
        let mockMainMenuInteractor = MockMainMenuInteractor()
        let mockNewGameInteractor = MockNewGameInteractor()
        
        // Act
        let splashView = factory.makeView(for: .splash)
        let mainMenuView = factory.makeView(for: .mainMenu(presenter: mockMainMenuInteractor))
        let newGameView = factory.makeView(for: .newGame(presenter: mockNewGameInteractor))
        
        // Assert
        #expect(splashView != nil)
        #expect(mainMenuView != nil)
        #expect(newGameView != nil)
    }
    
    @Test("ViewFactory can create multiple views of same type")
    @MainActor
    func testCanCreateMultipleViewsOfSameType() {
        // Arrange
        let factory = ViewFactory()
        let mockInteractor1 = MockMainMenuInteractor()
        let mockInteractor2 = MockMainMenuInteractor()
        
        // Act
        let view1 = factory.makeView(for: .mainMenu(presenter: mockInteractor1))
        let view2 = factory.makeView(for: .mainMenu(presenter: mockInteractor2))
        
        // Assert
        #expect(view1 != nil)
        #expect(view2 != nil)
    }
    
    // MARK: - Tab Container Tests
    
    @Test("ViewFactory creates tab container with empty tabs array")
    @MainActor
    func testCreatesTabContainerWithEmptyTabsArray() {
        // Arrange
        let factory = ViewFactory()
        let emptyTabs: [TabConfiguration] = []
        
        // Act
        let view = factory.makeView(for: .tabContainer(tabs: emptyTabs))
        
        // Assert
        #expect(view != nil)
    }
    
    @Test("ViewFactory creates tab container with single tab")
    @MainActor
    func testCreatesTabContainerWithSingleTab() {
        // Arrange
        let factory = ViewFactory()
        let singleTab: [TabConfiguration] = [
            TabConfiguration(type: .team, title: "Team", iconName: "person.3")
        ]
        
        // Act
        let view = factory.makeView(for: .tabContainer(tabs: singleTab))
        
        // Assert
        #expect(view != nil)
    }
    
    @Test("ViewFactory creates tab container with multiple tabs")
    @MainActor
    func testCreatesTabContainerWithMultipleTabs() {
        // Arrange
        let factory = ViewFactory()
        let multipleTabs: [TabConfiguration] = [
            TabConfiguration(type: .team, title: "Team", iconName: "person.3"),
            TabConfiguration(type: .team, title: "Team 2", iconName: "person.3.fill")
        ]
        
        // Act
        let view = factory.makeView(for: .tabContainer(tabs: multipleTabs))
        
        // Assert
        #expect(view != nil)
    }
    
    // MARK: - Edge Cases
    
    @Test("ViewFactory handles rapid view creation")
    @MainActor
    func testHandlesRapidViewCreation() {
        // Arrange
        let factory = ViewFactory()
        let mockInteractor = MockMainMenuInteractor()
        
        // Act - Create multiple views rapidly
        let view1 = factory.makeView(for: .mainMenu(presenter: mockInteractor))
        let view2 = factory.makeView(for: .mainMenu(presenter: mockInteractor))
        let view3 = factory.makeView(for: .mainMenu(presenter: mockInteractor))
        
        // Assert
        #expect(view1 != nil)
        #expect(view2 != nil)
        #expect(view3 != nil)
    }
    
    @Test("ViewFactory works with different interactor instances")
    @MainActor
    func testWorksWithDifferentInteractorInstances() {
        // Arrange
        let factory = ViewFactory()
        let interactor1 = MockMainMenuInteractor()
        let interactor2 = MockMainMenuInteractor()
        
        // Act
        let view1 = factory.makeView(for: .mainMenu(presenter: interactor1))
        let view2 = factory.makeView(for: .mainMenu(presenter: interactor2))
        
        // Assert
        #expect(view1 != nil)
        #expect(view2 != nil)
    }
    
    // MARK: - Mock ViewFactory Tests
    
    @Test("MockViewFactory tracks screens made")
    @MainActor
    func testMockViewFactoryTracksScreensMade() {
        // Arrange
        let mockFactory = MockViewFactory()
        let mockInteractor = MockMainMenuInteractor()
        
        // Act
        _ = mockFactory.makeView(for: .splash)
        _ = mockFactory.makeView(for: .mainMenu(presenter: mockInteractor))
        _ = mockFactory.makeView(for: .newGame(presenter: MockNewGameInteractor()))
        
        // Assert
        #expect(mockFactory.screensMade.count == 3)
        #expect(mockFactory.screensMade[0] == .splash)
        #expect(mockFactory.screensMade[1] == .mainMenu(presenter: mockInteractor))
    }
    
    @Test("MockViewFactory creates views for all screen types")
    @MainActor
    func testMockViewFactoryCreatesViewsForAllScreenTypes() {
        // Arrange
        let mockFactory = MockViewFactory()
        let mockMainMenuInteractor = MockMainMenuInteractor()
        let mockNewGameInteractor = MockNewGameInteractor()
        let mockTeamSelectInteractor = MockTeamSelectInteractor()
        let mockTeamInteractor = MockTeamInteractor()
        let tabs: [TabConfiguration] = [
            TabConfiguration(type: .team, title: "Team", iconName: "person.3")
        ]
        
        // Act
        let splashView = mockFactory.makeView(for: .splash)
        let mainMenuView = mockFactory.makeView(for: .mainMenu(presenter: mockMainMenuInteractor))
        let newGameView = mockFactory.makeView(for: .newGame(presenter: mockNewGameInteractor))
                    let teamSelectView = mockFactory.makeView(for: .teamSelect(presenter: mockTeamSelectInteractor))
        let teamView = mockFactory.makeView(for: .team(presenter: mockTeamInteractor))
        let tabContainerView = mockFactory.makeView(for: .tabContainer(tabs: tabs))
        
        // Assert
        #expect(splashView != nil)
        #expect(mainMenuView != nil)
        #expect(newGameView != nil)
        #expect(teamSelectView != nil)
        #expect(teamView != nil)
        #expect(tabContainerView != nil)
    }
    
    // MARK: - Performance Tests
    
    @Test("ViewFactory creates views efficiently")
    @MainActor
    func testCreatesViewsEfficiently() {
        // Arrange
        let factory = ViewFactory()
        let mockInteractor = MockMainMenuInteractor()
        
        // Act - Create multiple views to test performance
        let startTime = Date()
        
        for _ in 0..<100 {
            _ = factory.makeView(for: .mainMenu(presenter: mockInteractor))
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        // Assert - Should complete quickly (less than 1 second for 100 views)
        #expect(duration < 1.0)
    }
}
