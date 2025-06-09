//
//  NewGameFeatureCoordinator.swift
//  SuperSoccer
//
//  Created by Wesley on 5/28/25.
//

import Foundation
import Combine

enum NewGameCoordinatorResult: CoordinatorResult {
    case gameCreated(CreateNewCareerResult)
    case cancelled
}

protocol NewGameFeatureCoordinatorProtocol: AnyObject {
    var state: NewGameState { get }
    var statePublisher: AnyPublisher<NewGameState, Never> { get }
    
    func updateCoachInfo(firstName: String, lastName: String)
    func startTeamSelection()
    func createGame() async
}

class NewGameFeatureCoordinator: BaseFeatureCoordinator<NewGameCoordinatorResult>, NewGameFeatureCoordinatorProtocol, ObservableObject {
    private let navigationCoordinator: NavigationCoordinatorProtocol
    private let coordinatorRegistry: FeatureCoordinatorRegistryProtocol
    private let dataManager: DataManagerProtocol
    
    @Published private(set) var state = NewGameState()
    var statePublisher: AnyPublisher<NewGameState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    private var selectedTeamInfo: TeamInfo?
    private var coachFirstName: String = ""
    private var coachLastName: String = ""
    
    init(navigationCoordinator: NavigationCoordinatorProtocol, 
         coordinatorRegistry: FeatureCoordinatorRegistryProtocol,
         dataManager: DataManagerProtocol) {
        self.navigationCoordinator = navigationCoordinator
        self.coordinatorRegistry = coordinatorRegistry
        self.dataManager = dataManager
        super.init()
    }
    
    override func start() {
        coordinatorRegistry.register(self, for: .newGame)
        navigationCoordinator.navigateToScreen(.newGame)
    }
    
    override func finish(with result: NewGameCoordinatorResult) {
        coordinatorRegistry.unregister(for: .newGame)
        super.finish(with: result)
    }
    
    func updateCoachInfo(firstName: String, lastName: String) {
        coachFirstName = firstName
        coachLastName = lastName
        updateState()
    }
    
    func startTeamSelection() {
        let teamSelectCoordinator = TeamSelectFeatureCoordinator(
            navigationCoordinator: navigationCoordinator,
            coordinatorRegistry: coordinatorRegistry,
            dataManager: dataManager
        )
        
        startChild(teamSelectCoordinator) { [weak self] result in
            switch result {
            case .teamSelected(let teamInfo):
                self?.selectedTeamInfo = teamInfo
                self?.navigationCoordinator.dismissSheet()
                self?.updateState()
            case .cancelled:
                self?.navigationCoordinator.dismissSheet()
            }
        }
    }
    
    func createGame() async {
        guard let teamInfo = selectedTeamInfo,
              !coachFirstName.isEmpty,
              !coachLastName.isEmpty else { return }
        
//        updateState(isLoading: true)
        
        let request = CreateNewCareerRequest(
            coachFirstName: coachFirstName,
            coachLastName: coachLastName,
            selectedTeamInfoId: teamInfo.id,
            leagueName: "Premier League", // Default league name
            seasonYear: 2025
        )
        
        do {
            let result = try await dataManager.createNewCareer(request)
            print("Career created successfully: \(result.careerId)")
//            updateState(isLoading: false)
            finish(with: .gameCreated(result))
        } catch {
            print("Error creating career: \(error)")
//            updateState(isLoading: false)
            // TODO: Handle error appropriately
        }
    }

    private func updateState() {
        let coachInfo = CoachInfo(firstName: coachFirstName, lastName: coachLastName)
        state = NewGameState(selectedTeam: selectedTeamInfo, coachInfo: coachInfo)
    }
    
    private func handleError(_ error: Error) {
        // Handle error appropriately
        print("Error in NewGame: \(error)")
    }
}

#if DEBUG
class MockNewGameFeatureCoordinator: NewGameFeatureCoordinatorProtocol {
    @Published var state = NewGameState()
    var statePublisher: AnyPublisher<NewGameState, Never> {
        $state.eraseToAnyPublisher()
    }
    
    // Test tracking properties
    var updateCoachInfoCalled = false
    var startTeamSelectionCalled = false
    var createGameCalled = false
    var lastCoachInfo: (firstName: String, lastName: String)?
    
    func updateCoachInfo(firstName: String, lastName: String) {
        updateCoachInfoCalled = true
        lastCoachInfo = (firstName, lastName)
        state = NewGameState(
            selectedTeam: state.selectedTeam,
            coachInfo: CoachInfo(firstName: firstName, lastName: lastName)
        )
    }
    
    func startTeamSelection() {
        startTeamSelectionCalled = true
    }
    
    func createGame() async {
        createGameCalled = true
    }
}
#endif
