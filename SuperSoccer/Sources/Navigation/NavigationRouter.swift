import SwiftUI
import Combine

@Observable
final class NavigationRouter: ObservableObject {
    var path = NavigationPath()
    var presentedSheet: Screen?
    
    enum Screen: Hashable, Identifiable {
        case teamSelect
        case teamDetail(teamId: String)
        case playerList(teamId: String)
        
        var id: String {
            switch self {
            case .teamSelect: return "teamSelect"
            case .teamDetail(let id): return "teamDetail-\(id)"
            case .playerList(let id): return "playerList-\(id)"
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
