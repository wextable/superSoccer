//
//  TabNavigationManager.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI
import Combine

@MainActor
class TabNavigationManager: ObservableObject {
    static let shared = TabNavigationManager()
    
    @Published var tabNavigationPaths: [TabType: NavigationPath] = [:]
    @Published var tabScreenStacks: [TabType: [NavigationRouter.Screen]] = [:]
    
    private init() {}
    
    func navigate(to screen: NavigationRouter.Screen, in tab: TabType) {
        var path = tabNavigationPaths[tab] ?? NavigationPath()
        path.append(screen)
        tabNavigationPaths[tab] = path
        
        var screens = tabScreenStacks[tab] ?? []
        screens.append(screen)
        tabScreenStacks[tab] = screens
    }
    
    func replaceStack(with screen: NavigationRouter.Screen, in tab: TabType) {
        tabNavigationPaths[tab] = NavigationPath()
        tabScreenStacks[tab] = [screen]
    }
    
    func popToRoot(in tab: TabType) {
        tabNavigationPaths[tab] = NavigationPath()
        tabScreenStacks[tab] = []
    }
    
    func pop(in tab: TabType) {
        guard var path = tabNavigationPaths[tab], !path.isEmpty else { return }
        path.removeLast()
        tabNavigationPaths[tab] = path
        
        if var screens = tabScreenStacks[tab], !screens.isEmpty {
            screens.removeLast()
            tabScreenStacks[tab] = screens
        }
    }
    
    func clearAllTabs() {
        tabNavigationPaths.removeAll()
        tabScreenStacks.removeAll()
    }
}
