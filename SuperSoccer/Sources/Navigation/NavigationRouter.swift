import SwiftUI
import Combine

final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedSheet: Screen?
    
    enum Screen: Hashable, Identifiable {
        case newGame
        case teamSelect(onFinish: ((TeamInfo) -> Void))
        case teamDetail(teamInfo: TeamInfo)
        
        var id: String {
            switch self {
            case .newGame: return "newGame"
            case .teamSelect: return "teamSelect"
            case .teamDetail(let info): return "teamDetail-\(info.id)"
            }
        }
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.newGame, .newGame): return true
            case (.teamSelect, .teamSelect): return true
            case let (.teamDetail(lhsInfo), .teamDetail(rhsInfo)): return lhsInfo == rhsInfo
            default: return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .newGame:
                hasher.combine("newGame")
            case .teamSelect:
                hasher.combine("teamSelect")
            case .teamDetail(let info):
                hasher.combine("teamDetail")
                hasher.combine(info)
            }
        }
    }
    
    func navigate(to screen: Screen) {
        path.append(screen)
    }
    
    func replaceNavigationStack(with screen: Screen) {
        path = NavigationPath([screen])
    }
    
    func popToRoot() {
        path = NavigationPath()
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
}
