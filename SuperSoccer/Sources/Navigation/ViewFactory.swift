//
//  ViewFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

import SwiftUI

protocol ViewFactoryProtocol {
    func makeSplashView() -> SplashView
    func makeMainMenuView() -> MainMenuView<MainMenuInteractor>
    func makeNewGameView() -> NewGameView<NewGameInteractor>
    func makeTeamSelectView() -> TeamSelectView<TeamSelectInteractor>
    func makeView(for screen: NavigationRouter.Screen) -> AnyView
}

final class ViewFactory: ViewFactoryProtocol {
    private let coordinatorRegistry: FeatureCoordinatorRegistryProtocol
    private let dataManager: DataManagerProtocol
    
    init(coordinatorRegistry: FeatureCoordinatorRegistryProtocol, 
         dataManager: DataManagerProtocol) {
        self.coordinatorRegistry = coordinatorRegistry
        self.dataManager = dataManager
    }
    
    func makeView(for screen: NavigationRouter.Screen) -> AnyView {
        switch screen {
        case .splash:
            return AnyView(makeSplashView())
        case .mainMenu:
            return AnyView(makeMainMenuView())
        case .newGame:
            return AnyView(makeNewGameView())
        case .teamSelect:
            return AnyView(makeTeamSelectView())
        }
    }
    
    func makeSplashView() -> SplashView {
        return SplashView()
    }
    
    func makeMainMenuView() -> MainMenuView<MainMenuInteractor> {
        guard let coordinator = coordinatorRegistry.coordinator(
            for: .mainMenu,
            as: MainMenuFeatureCoordinatorProtocol.self
        ) else {
            fatalError("MainMenuFeatureCoordinator must be active before creating view")
        }
        
        let interactor = MainMenuInteractor(
            featureCoordinator: coordinator,
            dataManager: dataManager
        )
        return MainMenuView(interactor: interactor)
    }
    
    func makeNewGameView() -> NewGameView<NewGameInteractor> {
        guard let coordinator = coordinatorRegistry.coordinator(
            for: .newGame, 
            as: NewGameFeatureCoordinatorProtocol.self
        ) else {
            fatalError("NewGameFeatureCoordinator must be active before creating view")
        }
        
        let interactor = NewGameInteractor(featureCoordinator: coordinator)
        return NewGameView(interactor: interactor)
    }
    
    func makeTeamSelectView() -> TeamSelectView<TeamSelectInteractor> {
        guard let coordinator = coordinatorRegistry.coordinator(
            for: .teamSelect,
            as: TeamSelectFeatureCoordinatorProtocol.self
        ) else {
            fatalError("TeamSelectFeatureCoordinator must be active before creating view")
        }
        
        let interactor = TeamSelectInteractor(
            featureCoordinator: coordinator,
            dataManager: dataManager
        )
        return TeamSelectView(interactor: interactor)
    }
}

#if DEBUG
class MockViewFactory: ViewFactoryProtocol {
    var makeSplashViewCalled = false
    var makeMainMenuViewCalled = false
    var makeNewGameViewCalled = false
    var makeTeamSelectViewCalled = false
    
    func makeView(for screen: NavigationRouter.Screen) -> AnyView {
        switch screen {
        case .splash:
            return AnyView(makeSplashView())
        case .mainMenu:
            return AnyView(makeMainMenuView())
        case .newGame:
            return AnyView(makeNewGameView())
        case .teamSelect:
            return AnyView(makeTeamSelectView())
        }
    }
    
    func makeSplashView() -> SplashView {
        makeSplashViewCalled = true
        return SplashView()
    }
    
    func makeMainMenuView() -> MainMenuView<MainMenuInteractor> {
        makeMainMenuViewCalled = true
        let mockCoordinator = MockMainMenuFeatureCoordinator()
        let mockDataManager = MockDataManager()
        let interactor = MainMenuInteractor(featureCoordinator: mockCoordinator, dataManager: mockDataManager)
        return MainMenuView(interactor: interactor)
    }
    
    func makeNewGameView() -> NewGameView<NewGameInteractor> {
        makeNewGameViewCalled = true
        let mockCoordinator = MockNewGameFeatureCoordinator()
        let interactor = NewGameInteractor(featureCoordinator: mockCoordinator)
        return NewGameView(interactor: interactor)
    }
    
    func makeTeamSelectView() -> TeamSelectView<TeamSelectInteractor> {
        makeTeamSelectViewCalled = true
        let mockCoordinator = MockTeamSelectFeatureCoordinator()
        let mockDataManager = MockDataManager()
        let interactor = TeamSelectInteractor(
            featureCoordinator: mockCoordinator,
            dataManager: mockDataManager
        )
        return TeamSelectView(interactor: interactor)
    }
}
#endif
