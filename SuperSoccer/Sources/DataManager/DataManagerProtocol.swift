//
//  DataManagerProtocol.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Combine
import Foundation

protocol DataManagerProtocol {
    var teamPublisher: AnyPublisher<[TeamClientModel], Never> { get }
    func addNewTeam(_ team: SDTeam)
    func deleteTeams(at offsets: IndexSet)
}

#if DEBUG
class MockDataManager: DataManagerProtocol {
    var mockTeams: [TeamClientModel] = []
    var teamPublisher: AnyPublisher<[TeamClientModel], Never> {
        Just(mockTeams).eraseToAnyPublisher()
    }
    
    var mockAddedTeam: TeamClientModel = .make()
    func addNewTeam(_ team: SDTeam) {
        mockTeams.append(mockAddedTeam)
    }
    
    func deleteTeams(at offsets: IndexSet) {
        mockTeams.remove(atOffsets: offsets)
    }
}
#endif
