//
//  NewGameInteractor.swift
//  SuperSoccer
//
//  Created by Wesley on 5/23/25.
//

import Combine
import Observation
import SwiftUI

protocol NewGameBusinessLogicDelegate: AnyObject {
    func businessLogicDidRequestTeamSelection()
    func businessLogicDidCreateGame(with result: CreateNewCareerResult)
    func businessLogicDidCancel()
}

protocol NewGameBusinessLogic: AnyObject {
    var delegate: NewGameBusinessLogicDelegate? { get set }
    func updateSelectedTeam(_ teamInfo: TeamInfo)
}

protocol NewGameViewPresenter: AnyObject {
    var viewModel: NewGameViewModel { get }
    func bindFirstName() -> Binding<String>
    func bindLastName() -> Binding<String>
    func submitTapped()
    func teamSelectorTapped()
}

protocol NewGameInteractorProtocol: NewGameBusinessLogic & NewGameViewPresenter {}

@Observable
final class NewGameInteractor: NewGameInteractorProtocol {
    private let dataManager: DataManagerProtocol
    private let localDataSource: NewGameLocalDataSourceProtocol
    
    weak var delegate: NewGameBusinessLogicDelegate?
    
    var viewModel: NewGameViewModel = .init()
    private let newGameViewModelTransform: NewGameViewModelTransformProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(
        dataManager: DataManagerProtocol,
        localDataSource: NewGameLocalDataSourceProtocol = NewGameLocalDataSource(),
        newGameViewModelTransform: NewGameViewModelTransformProtocol = NewGameViewModelTransform()
    ) {
        self.dataManager = dataManager
        self.localDataSource = localDataSource
        self.newGameViewModelTransform = newGameViewModelTransform
        setupSubscriptions()
    }
    
    private func setupSubscriptions() {
        subscribeToDataSources()
    }
    
    private func subscribeToDataSources() {
        localDataSource.dataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let self else { return }
                self.viewModel = self.newGameViewModelTransform.transform(localData: data)
            }
            .store(in: &cancellables)
    }
    
    func bindFirstName() -> Binding<String> {
        Binding(
            get: { self.viewModel.coachFirstName },
            set: { newValue in
                self.localDataSource.updateCoach(firstName: newValue)
            }
        )
    }
    
    func bindLastName() -> Binding<String> {
        Binding(
            get: { self.viewModel.coachLastName },
            set: { newValue in
                self.localDataSource.updateCoach(lastName: newValue)
            }
        )
    }
    
    func submitTapped() {
        Task {
            await self.createGame()
        }
    }
    
    func teamSelectorTapped() {
        delegate?.businessLogicDidRequestTeamSelection()
    }

    func updateSelectedTeam(_ teamInfo: TeamInfo) {
        localDataSource.updateSelectedTeam(teamInfo)
    }
    
    private func createGame() async {
        guard localDataSource.data.canSubmit,
              let teamInfo = localDataSource.data.selectedTeamInfo else {
            return
        }
        
        let request = CreateNewCareerRequest(
            coachFirstName: localDataSource.data.coachFirstName,
            coachLastName: localDataSource.data.coachLastName,
            selectedTeamInfoId: teamInfo.id,
            leagueName: "Premier League", // Default league name
            seasonYear: 2025
        )
        
        do {
            let result = try await dataManager.createNewCareer(request)
            print("Career created successfully: \(result.careerId)")
            
            // Ensure delegate call happens on main thread for UI updates and testing
            await MainActor.run {
                delegate?.businessLogicDidCreateGame(with: result)
            }
        } catch {
            print("Error creating career: \(error)")
            // TODO: Handle error appropriately
        }
    }
}

// MARK: - Debug Extensions (ONLY to be used in unit tests and preview providers)

#if DEBUG
extension NewGameInteractor {
    var testHooks: TestHooks { TestHooks(target: self) }
    
    struct TestHooks {
        let target: NewGameInteractor        
    }
}

class MockNewGameInteractor: NewGameInteractorProtocol {
    var viewModel: NewGameViewModel = .make()
    weak var delegate: NewGameBusinessLogicDelegate?
    
    // Test tracking properties
    var bindFirstNameCalled = false
    var bindLastNameCalled = false
    var updateSelectedTeamCalled = false
    var submitTappedCalled = false
    var teamSelectorTappedCalled = false
    var lastUpdatedTeam: TeamInfo?
    
    // Callback support for async testing
    var onBindFirstName: (() -> Void)?
    var onBindLastName: (() -> Void)?
    var onUpdateSelectedTeam: ((TeamInfo) -> Void)?
    var onSubmitTapped: (() -> Void)?
    var onTeamSelectorTapped: (() -> Void)?
    
    private var firstName = ""
    private var lastName = ""
    
    func bindFirstName() -> Binding<String> {
        bindFirstNameCalled = true
        onBindFirstName?()
        return Binding(
            get: { self.firstName },
            set: { self.firstName = $0 }
        )
    }
    
    func bindLastName() -> Binding<String> {
        bindLastNameCalled = true
        onBindLastName?()
        return Binding(
            get: { self.lastName },
            set: { self.lastName = $0 }
        )
    }
    
    func updateSelectedTeam(_ teamInfo: TeamInfo) {
        updateSelectedTeamCalled = true
        lastUpdatedTeam = teamInfo
        onUpdateSelectedTeam?(teamInfo)
    }
    
    func submitTapped() {
        submitTappedCalled = true
        onSubmitTapped?()
    }
    
    func teamSelectorTapped() {
        teamSelectorTappedCalled = true
        onTeamSelectorTapped?()
    }
}

class MockNewGameInteractorDelegate: NewGameBusinessLogicDelegate {
    var didRequestTeamSelection = false
    var didCreateGameCalled = false
    var didCancelCalled = false
    var lastCreateGameResult: CreateNewCareerResult?
    
    // Callback support for async testing patterns
    var onDidRequestTeamSelection: (() -> Void)?
    var onDidCreateGame: ((CreateNewCareerResult) -> Void)?
    var onDidCancel: (() -> Void)?
    
    func businessLogicDidRequestTeamSelection() {
        didRequestTeamSelection = true
        onDidRequestTeamSelection?()
    }
    
    func businessLogicDidCreateGame(with result: CreateNewCareerResult) {
        didCreateGameCalled = true
        lastCreateGameResult = result
        onDidCreateGame?(result)
    }
    
    func businessLogicDidCancel() {
        didCancelCalled = true
        onDidCancel?()
    }
}

#endif
