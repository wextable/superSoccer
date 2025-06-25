//
//  RootCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Foundation
import Combine

enum RootCoordinatorResult: CoordinatorResult {
    case appShouldExit
}

class RootCoordinator: BaseFeatureCoordinator<RootCoordinatorResult> {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    private var splashTimer: Timer?
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        super.init()
    }
    
    override func start() {
        startSplashTimer()
    }
    
    private func startSplashTimer() {
        // Start a 3-second timer for the splash screen
        splashTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.splashTimer?.invalidate()
            self.splashTimer = nil
            self.startMainMenuFlow()
        }
    }
    
    deinit {
        splashTimer?.invalidate()
        splashTimer = nil
    }
        
    private func startMainMenuFlow() {
        let mainMenuCoordinator = MainMenuFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            dataManager: dataManager
        )
        
        // Start the coordinator first so it registers itself
        startChild(mainMenuCoordinator) { [weak self] result in
            switch result {
            case .newGameCreated(let createGameResult):
                self?.startInGameFlow(with: createGameResult)
            }
        }
    }
    
    private func startInGameFlow(with careerResult: CreateNewCareerResult) {
        let inGameCoordinator = InGameCoordinator(
            careerResult: careerResult,
            navigationCoordinator: navigationCoordinator,
            dataManager: dataManager
        )
        
        startChild(inGameCoordinator) { [weak self] result in
            switch result {
            case .exitToMainMenu:
                self?.startMainMenuFlow()
            }
        }
    }
    
}

#if DEBUG
extension RootCoordinator {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: RootCoordinator
        
        var childCoordinators: [any BaseFeatureCoordinatorType] { target.testChildCoordinators }
        var navigationCoordinator: NavigationCoordinatorProtocol { target.navigationCoordinator }
        var dataManager: DataManagerProtocol { target.dataManager }
        var splashTimer: Timer? { target.splashTimer }
        
        func simulateChildFinish<ChildResult: CoordinatorResult>(
            _ childCoordinator: BaseFeatureCoordinator<ChildResult>,
            with result: ChildResult
        ) {
            childCoordinator.finish(with: result)
        }
    }
}

#endif
