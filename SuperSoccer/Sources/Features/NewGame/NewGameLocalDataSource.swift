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
        
        var canSubmit: Bool {
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

#if DEBUG
class MockNewGameLocalDataSource: NewGameLocalDataSourceProtocol {
    private let dataSubject = CurrentValueSubject<NewGameLocalDataSource.Data, Never>(
        NewGameLocalDataSource.Data(
            coachFirstName: "",
            coachLastName: "",
            selectedTeamInfo: nil
        )
    )
    
    var dataPublisher: AnyPublisher<NewGameLocalDataSource.Data, Never> {
        dataSubject.eraseToAnyPublisher()
    }
    
    var data: NewGameLocalDataSource.Data {
        dataSubject.value
    }
    
    // Test tracking properties
    var lastUpdatedFirstName: String?
    var lastUpdatedLastName: String?
    var lastUpdatedTeamInfo: TeamInfo?
    var isDataValid: Bool = false
    
    func updateCoach(firstName: String) {
        lastUpdatedFirstName = firstName
        var currentData = dataSubject.value
        currentData.coachFirstName = firstName
        dataSubject.send(currentData)
    }
    
    func updateCoach(lastName: String) {
        lastUpdatedLastName = lastName
        var currentData = dataSubject.value
        currentData.coachLastName = lastName
        dataSubject.send(currentData)
    }
    
    func updateSelectedTeam(_ teamInfo: TeamInfo?) {
        lastUpdatedTeamInfo = teamInfo
        var currentData = dataSubject.value
        currentData.selectedTeamInfo = teamInfo
        dataSubject.send(currentData)
    }
    
    // Test helper method
    func updateData(
        coachFirstName: String,
        coachLastName: String,
        selectedTeamInfo: TeamInfo?,
        canSubmit: Bool
    ) {
        let newData = NewGameLocalDataSource.Data(
            coachFirstName: coachFirstName,
            coachLastName: coachLastName,
            selectedTeamInfo: selectedTeamInfo
        )
        dataSubject.send(newData)
    }
}
#endif
