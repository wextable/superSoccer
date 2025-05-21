//
//  RootCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Observation

@Observable
final class RootCoordinator {
    enum AppState {
        case splash
        case main
    }

    var appState: AppState = .splash

    func transitionToMain() {
        appState = .main
    }
}
