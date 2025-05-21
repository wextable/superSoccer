//
//  DataManager.swift
//  SuperSoccer
//
//  Created by Wesley on 4/4/25.
//

import Combine
import Foundation

protocol DataManager {
    var teamPublisher: AnyPublisher<[TeamClientModel], Never> { get }
    func addNewTeam()
    func addNewTeam(_ team: SDTeam)
    func deleteTeams(at offsets: IndexSet)
}
