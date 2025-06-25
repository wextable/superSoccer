//
//  DataManagerFactoryProtocol.swift
//  SuperSoccer
//
//  Created by Wesley on 5/20/25.
//

import Foundation

@MainActor
protocol DataManagerFactoryProtocol {
    func makeDataManager() -> DataManagerProtocol
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
class MockDataManagerFactory: DataManagerFactoryProtocol {
    func makeDataManager() -> DataManagerProtocol {
        return MockDataManager()
    }
}
#endif
