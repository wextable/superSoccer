//
//  TabContainerView.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import SwiftUI

struct TabContainerView: View {
    let tabs: [TabConfiguration]
    @StateObject private var tabNavigationManager = TabNavigationManager.shared
    @State private var selectedTab: TabType
    private let viewFactory: ViewFactoryProtocol
    
    init(tabs: [TabConfiguration], viewFactory: ViewFactoryProtocol) {
        self.tabs = tabs
        self.viewFactory = viewFactory
        self._selectedTab = State(initialValue: tabs.first?.type ?? .team)
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ForEach(tabs) { tabConfig in
                NavigationStack(path: bindingForTab(tabConfig.type)) {
                    initialViewForTab(tabConfig.type)
                        .navigationDestination(for: NavigationRouter.Screen.self) { screen in
                            viewFactory.makeView(for: screen)
                        }
                }
                .tabItem {
                    Image(systemName: tabConfig.iconName)
                    Text(tabConfig.title)
                }
                .tag(tabConfig.type)
            }
        }
    }
    
    @ViewBuilder
    private func initialViewForTab(_ tabType: TabType) -> some View {
        // Show the root screen for each tab based on what's in the stack
        if let screens = tabNavigationManager.tabScreenStacks[tabType],
           let rootScreen = screens.first {
            viewFactory.makeView(for: rootScreen)
        } else {
            // Default empty view if no root screen is set
            Color.clear
        }
    }
    
    private func bindingForTab(_ tab: TabType) -> Binding<NavigationPath> {
        Binding(
            get: { tabNavigationManager.tabNavigationPaths[tab] ?? NavigationPath() },
            set: { tabNavigationManager.tabNavigationPaths[tab] = $0 }
        )
    }
    
    static func make(tabs: [TabConfiguration], viewFactory: ViewFactoryProtocol) -> TabContainerView {
        return TabContainerView(tabs: tabs, viewFactory: viewFactory)
    }
}
