//
//  DataManagerProtocol.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Combine
import Foundation

protocol DataManagerProtocol {
    func teamInfos() -> [TeamInfo]
    var teamPublisher: AnyPublisher<[Team], Never> { get } // FIXMEEEEEEEEEEEE
    func addNewTeam(_ team: Team)
    func deleteTeams(at offsets: IndexSet)
    func addCoach(_ coach: Coach)
}

#if DEBUG
class MockDataManager: DataManagerProtocol {
    var mockCoaches: [Coach] = []
    @Published var mockTeams: [Team] = []
    lazy var teamPublisher: AnyPublisher<[Team], Never> = $mockTeams.eraseToAnyPublisher()
    
    var mockTeamInfos: [TeamInfo] = [TeamInfo.make()]
    func teamInfos() -> [TeamInfo] {
        return mockTeamInfos
    }
    
    var mockAddedTeam: Team = .make()
    func addNewTeam(_ team: Team) {
        mockTeams.append(mockAddedTeam)
    }
    
    func deleteTeams(at offsets: IndexSet) {
        mockTeams.remove(atOffsets: offsets)
    }
    
    func addCoach(_ coach: Coach) {
        mockCoaches.append(coach)
    }
}
#endif
