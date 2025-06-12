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

protocol RootCoordinatorProtocol: AnyObject {
}

class RootCoordinator: BaseFeatureCoordinator<RootCoordinatorResult>, RootCoordinatorProtocol, ObservableObject {
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
                // TODO: navigate to the team detail screen
                break
            }
        }
    }
    
}

#if DEBUG
class MockRootCoordinator: RootCoordinatorProtocol {
    var startCalled = false
    
    func start() {
        startCalled = true
    }
}
#endif
