//
//  SplashViewInteractorTests.swift
//  SuperSoccerTests
//
//  Created by Wesley on 5/21/25.
//

import Testing
import Combine
@testable import SuperSoccer

@MainActor
struct SplashViewInteractorTests {
    @Test func testInitialState() async throws {
        // Arrange
        let coordinator = RootCoordinator()
        let interactor = SplashViewInteractor(coordinator: coordinator)
        
        // Assert
        #expect(coordinator.appState == .splash)
        #expect(interactor.viewModel.imageAssetName == "SuperSoccerLaunch")
        #expect(interactor.viewModel.duration == 1.0)
    }
    
    @Test func testFinishedEventTransitionsToMain() async throws {
        // Arrange
        let coordinator = RootCoordinator()
        let interactor = SplashViewInteractor(coordinator: coordinator)
        
        // Pre-assert
        #expect(coordinator.appState == .splash)
        
        // Act
        interactor.eventBus.send(.finished)
        
        // Assert
        #expect(coordinator.appState == .main)
    }
    
    @Test func testFinishedEventOnlyTransitionsOnce() async throws {
        // Arrange
        let coordinator = RootCoordinator()
        let interactor = SplashViewInteractor(coordinator: coordinator)
        
        // Act - send finished event twice
        interactor.eventBus.send(.finished)
        coordinator.appState = .splash // Reset state
        interactor.eventBus.send(.finished)
        
        // Assert - second event should not trigger transition
        #expect(coordinator.appState == .splash)
    }
    
    @Test func testViewModelDefaultValues() async throws {
        // Arrange
        let coordinator = RootCoordinator()
        let interactor = SplashViewInteractor(coordinator: coordinator)
        
        // Assert
        #expect(interactor.viewModel.imageAssetName == "SuperSoccerLaunch")
        #expect(interactor.viewModel.duration == 1.0)
    }
}
