//
//  DataManagerFactory.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Foundation

@MainActor
protocol DataManagerFactory {
    func makeDataManager() -> DataManager
}
