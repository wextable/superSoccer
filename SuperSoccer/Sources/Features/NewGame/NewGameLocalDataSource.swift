//
//  NewGameLocalDataSource.swift
//  SuperSoccer
//
//  Created by Wesley on 6/11/25.
//

import Combine

protocol NewGameLocalDataSourceProtocol {
    var data: NewGameLocalDataSource.Data { get }
    var dataPublisher: AnyPublisher<NewGameLocalDataSource.Data, Never> { get }
    
    func updateCoach(firstName: String)
    func updateCoach(lastName: String)
    func updateSelectedTeam(_ teamInfo: TeamInfo?)
}

final class NewGameLocalDataSource: NewGameLocalDataSourceProtocol {
    struct Data {
        var coachFirstName: String = ""
        var coachLastName: String = ""
        var selectedTeamInfo: TeamInfo?
        
        var isValid: Bool {
            return !coachFirstName.isEmpty && !coachLastName.isEmpty && selectedTeamInfo != nil
        }
    }
    
    @Published private(set) var data: Data
    lazy var dataPublisher = $data.eraseToAnyPublisher()
    
    init(data: Data = Data()) {
        self.data = data
    }
    
    func updateCoach(firstName: String) {
        data.coachFirstName = firstName
    }

    func updateCoach(lastName: String) {
        data.coachLastName = lastName
    }

    func updateSelectedTeam(_ teamInfo: TeamInfo?) {
        data.selectedTeamInfo = teamInfo
    }
}
