//
//  InGameCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import Foundation

enum InGameCoordinatorResult: CoordinatorResult {
    case exitToMainMenu
}

class InGameCoordinator: BaseFeatureCoordinator<InGameCoordinatorResult> {
    private let careerResult: CreateNewCareerResult
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let dataManager: DataManagerProtocol
    
    init(careerResult: CreateNewCareerResult,
         navigationCoordinator: NavigationCoordinatorProtocol,
         dataManager: DataManagerProtocol) {
        self.careerResult = careerResult
        self.navigationCoordinator = navigationCoordinator
        self.dataManager = dataManager
        super.init()
    }
    
    override func start() {
        // Create tab configuration
        let tabs = createInGameTabs()
        
        // Replace navigation stack with tab container
        let tabContainerScreen = NavigationRouter.Screen.tabContainer(tabs: tabs)
        Task { @MainActor in
            self.navigationCoordinator.replaceStackWith(tabContainerScreen)
            
            // Start the individual tab coordinators
            self.startTeamTab()
        }
    }
    
    deinit {
        // Clear tab navigation state when coordinator is deallocated
        Task { @MainActor in
            TabNavigationManager.shared.clearAllTabs()
        }
    }
    
    private func createInGameTabs() -> [TabConfiguration] {
        return [
            TabConfiguration(type: .team, title: "Team", iconName: "person.3")
            // Future tabs can be added here:
            // TabConfiguration(type: .league, title: "League", iconName: "trophy"),
            // TabConfiguration(type: .settings, title: "Settings", iconName: "gear")
        ]
    }
    
    @MainActor
    private func startTeamTab() {
        let teamTabNavigationCoordinator = TabNavigationCoordinator(
            tab: .team,
            parentNavigationCoordinator: navigationCoordinator
        )
        
        let teamCoordinator = TeamFeatureCoordinator(
            userTeamId: careerResult.userTeamId,
            navigationCoordinator: teamTabNavigationCoordinator,
            interactorFactory: DependencyContainer.shared.interactorFactory
        )
        
        startChild(teamCoordinator) { [weak self] result in
            switch result {
            case .playerSelected(let playerId):
                // Future: Handle player selection, maybe start PlayerDetailCoordinator
                print("Player selected: \(playerId)")
            case .dismissed:
                // Handle if team coordinator is dismissed
                break
            }
        }
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
class MockInGameCoordinator: InGameCoordinator {
    var startCalled = false
    
    override func start() {
        startCalled = true
    }
}
#endif
