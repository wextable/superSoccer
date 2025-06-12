//
//  RootNavigationView.swift
//  SuperSoccer
//
//  Created by Wesley on 6/4/25.
//

import SwiftUI

struct RootNavigationView: View {
    @EnvironmentObject private var router: NavigationRouter
    let viewFactory: ViewFactoryProtocol
    
    var body: some View {
        // Show the appropriate view based on current navigation state
        NavigationStack(path: $router.path) {
            if router.screens.isEmpty {
                // No navigation screens, show splash
                viewFactory.makeView(for: .splash)
            } else {
                // Show the first screen in the navigation stack as the "root"
                // All other screens will be handled by NavigationConfigurator
                viewFactory.makeView(for: router.screens[0])
                    .modifier(NavigationConfigurator(viewFactory: viewFactory, router: router))
            }
        }
    }
}
