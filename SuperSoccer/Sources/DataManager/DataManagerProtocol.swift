//
//  DataManagerProtocol.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Combine
import Foundation

protocol DataManagerProtocol {
    var teamPublisher: AnyPublisher<[Team], Never> { get }
    func addNewTeam(_ team: Team)
    func deleteTeams(at offsets: IndexSet)
}

#if DEBUG
class MockDataManager: DataManagerProtocol {
    @Published var mockTeams: [Team] = []
    lazy var teamPublisher: AnyPublisher<[Team], Never> = $mockTeams.eraseToAnyPublisher()
    
    var mockAddedTeam: Team = .make()
    func addNewTeam(_ team: Team) {
        mockTeams.append(mockAddedTeam)
    }
    
    func deleteTeams(at offsets: IndexSet) {
        mockTeams.remove(atOffsets: offsets)
    }
}
#endif
