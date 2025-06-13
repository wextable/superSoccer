//
//  TabConfiguration.swift
//  SuperSoccer
//
//  Created by Wesley on 6/13/25.
//

import Foundation

struct TabConfiguration: Identifiable, Hashable {
    let id = UUID()
    let type: TabType
    let title: String
    let iconName: String
}

enum TabType: String, CaseIterable {
    case team = "team"
    // Future: case league = "league", case settings = "settings"
}
