//
//  SplashViewInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Combine
import Observation
import SwiftUI

typealias SplashEventBus = PassthroughSubject<SplashEvent, Never>

enum SplashEvent: BusEvent {
    case finished
}

protocol SplashViewInteractorProtocol: AnyObject {
    var viewModel: SplashViewModel { get }
    var eventBus: SplashEventBus { get }
}
    
@Observable
final class SplashViewInteractor: SplashViewInteractorProtocol {
    private let coordinator: RootCoordinator
    let eventBus = SplashEventBus()
    let viewModel = SplashViewModel(imageAssetName: "SuperSoccerLaunch", duration: 1.0)
    
    private var hasNavigated = false
    private var cancellables = Set<AnyCancellable>()
    
    init(coordinator: RootCoordinator) {
        self.coordinator = coordinator
        subscribeToEvents()
    }
    
    private func subscribeToEvents() {
        eventBus
            .sink { [weak self] event in
                guard let self, !hasNavigated else { return }
                switch event {
                case .finished:
                    hasNavigated = true
                    withAnimation {
                        self.coordinator.transitionToMain()
                    }
                }
            }
            .store(in: &cancellables)
    }
}

#if DEBUG
class MockSplashViewInteractor: SplashViewInteractorProtocol {
    var viewModel: SplashViewModel = SplashViewModel.make()
    var eventBus: SplashEventBus = SplashEventBus()
}
#endif
