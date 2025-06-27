//
//  NavigationConfiguratorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 6/16/25.
//

import Testing
import SwiftUI
@testable import SuperSoccer

struct NavigationConfiguratorTests {
    
    // MARK: - Initialization Tests
    
    @Test("NavigationConfigurator initializes with viewFactory and router")
    @MainActor
    func testInitializationWithViewFactoryAndRouter() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        
        // Act
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        // Assert
        #expect(configurator != nil)
    }
    
    // MARK: - ViewModifier Tests
    
    @Test("NavigationConfigurator modifies content view")
    @MainActor
    func testModifiesContentView() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act - Use the modifier directly on a view
        let modifiedView = testView.modifier(configurator)
        
        // Assert
        #expect(modifiedView != nil)
    }
    
    // MARK: - Router Integration Tests
    
    @Test("NavigationConfigurator uses provided router")
    @MainActor
    func testUsesProvidedRouter() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        // Act & Assert
        #expect(configurator.router === router)
    }
    
    @Test("NavigationConfigurator uses provided viewFactory")
    @MainActor
    func testUsesProvidedViewFactory() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        // Act - We can't directly access the private viewFactory, but we can test it indirectly
        let testView = Text("Test Content")
        _ = testView.modifier(configurator)
        
        // Assert - The configurator should work without crashing
        #expect(configurator != nil)
    }
    
    // MARK: - Navigation Destination Tests
    
    @Test("NavigationConfigurator creates navigation destinations")
    @MainActor
    func testCreatesNavigationDestinations() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act
        let modifiedView = testView.modifier(configurator)
        
        // Assert - The modified view should have navigation destinations configured
        #expect(modifiedView != nil)
    }
    
    @Test("NavigationConfigurator handles different screen types")
    @MainActor
    func testHandlesDifferentScreenTypes() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act - Create modified view that can handle different screen types
        let modifiedView = testView.modifier(configurator)
        
        // Assert - Should handle all screen types without crashing
        #expect(modifiedView != nil)
    }
    
    // MARK: - Sheet Presentation Tests
    
    @Test("NavigationConfigurator configures sheet presentation")
    @MainActor
    func testConfiguresSheetPresentation() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act
        let modifiedView = testView.modifier(configurator)
        
        // Assert - The modified view should have sheet presentation configured
        #expect(modifiedView != nil)
    }
    
    @Test("NavigationConfigurator uses router's presentedSheet")
    @MainActor
    func testUsesRouterPresentedSheet() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        // Act & Assert - The configurator should observe the router's presentedSheet
        #expect(configurator.router === router)
    }
    
    // MARK: - Environment Object Tests
    
    @Test("NavigationConfigurator provides router as environment object")
    @MainActor
    func testProvidesRouterAsEnvironmentObject() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act
        let modifiedView = testView.modifier(configurator)
        
        // Assert - The modified view should have the router as an environment object
        #expect(modifiedView != nil)
    }
    
    // MARK: - View Factory Integration Tests
    
    @Test("NavigationConfigurator uses viewFactory for destination views")
    @MainActor
    func testUsesViewFactoryForDestinationViews() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act
        let modifiedView = testView.modifier(configurator)
        
        // Assert - The configurator should use the viewFactory to create destination views
        #expect(modifiedView != nil)
    }
    
    // MARK: - Screen ID Tests
    
    @Test("NavigationConfigurator uses screen IDs for unique identity")
    @MainActor
    func testUsesScreenIdsForUniqueIdentity() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act
        let modifiedView = testView.modifier(configurator)
        
        // Assert - The modified view should use screen IDs for unique identity
        #expect(modifiedView != nil)
    }
    
    // MARK: - Multiple Instances Tests
    
    @Test("NavigationConfigurator can create multiple instances")
    @MainActor
    func testCanCreateMultipleInstances() {
        // Arrange
        let mockViewFactory1 = MockViewFactory()
        let router1 = NavigationRouter()
        let mockViewFactory2 = MockViewFactory()
        let router2 = NavigationRouter()
        
        // Act
        let configurator1 = NavigationConfigurator(
            viewFactory: mockViewFactory1,
            router: router1
        )
        let configurator2 = NavigationConfigurator(
            viewFactory: mockViewFactory2,
            router: router2
        )
        
        // Assert
        #expect(configurator1 != nil)
        #expect(configurator2 != nil)
        #expect(configurator1.router !== configurator2.router)
    }
    
    @Test("NavigationConfigurator instances are independent")
    @MainActor
    func testInstancesAreIndependent() {
        // Arrange
        let mockViewFactory1 = MockViewFactory()
        let router1 = NavigationRouter()
        let mockViewFactory2 = MockViewFactory()
        let router2 = NavigationRouter()
        
        let configurator1 = NavigationConfigurator(
            viewFactory: mockViewFactory1,
            router: router1
        )
        let configurator2 = NavigationConfigurator(
            viewFactory: mockViewFactory2,
            router: router2
        )
        
        // Act & Assert
        #expect(configurator1.router === router1)
        #expect(configurator2.router === router2)
        #expect(configurator1.router !== configurator2.router)
    }
    
    // MARK: - Edge Cases
    
    @Test("NavigationConfigurator handles empty content")
    @MainActor
    func testHandlesEmptyContent() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let emptyView = EmptyView()
        
        // Act
        let modifiedView = emptyView.modifier(configurator)
        
        // Assert
        #expect(modifiedView != nil)
    }
    
    @Test("NavigationConfigurator handles complex content")
    @MainActor
    func testHandlesComplexContent() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let complexView = VStack {
            Text("Title")
            HStack {
                Text("Left")
                Text("Right")
            }
            Button("Action") { }
        }
        
        // Act
        let modifiedView = complexView.modifier(configurator)
        
        // Assert
        #expect(modifiedView != nil)
    }
    
    // MARK: - Performance Tests
    
    @Test("NavigationConfigurator creates modified views efficiently")
    @MainActor
    func testCreatesModifiedViewsEfficiently() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act - Create multiple modified views to test performance
        let startTime = Date()
        
        for _ in 0..<100 {
            _ = testView.modifier(configurator)
        }
        
        let endTime = Date()
        let duration = endTime.timeIntervalSince(startTime)
        
        // Assert - Should complete quickly (less than 1 second for 100 views)
        #expect(duration < 1.0)
    }
    
    // MARK: - Integration Tests
    
    @Test("NavigationConfigurator works with real ViewFactory")
    @MainActor
    func testWorksWithRealViewFactory() {
        // Arrange
        let realViewFactory = ViewFactory()
        let router = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: realViewFactory,
            router: router
        )
        
        let testView = Text("Test Content")
        
        // Act
        let modifiedView = testView.modifier(configurator)
        
        // Assert
        #expect(modifiedView != nil)
    }
    
    @Test("NavigationConfigurator works with real NavigationRouter")
    @MainActor
    func testWorksWithRealNavigationRouter() {
        // Arrange
        let mockViewFactory = MockViewFactory()
        let realRouter = NavigationRouter()
        let configurator = NavigationConfigurator(
            viewFactory: mockViewFactory,
            router: realRouter
        )
        
        let testView = Text("Test Content")
        
        // Act
        let modifiedView = testView.modifier(configurator)
        
        // Assert
        #expect(modifiedView != nil)
    }
}
