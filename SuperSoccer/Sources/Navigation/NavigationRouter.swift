import SwiftUI
import Combine

final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var presentedSheet: Screen?
    
    enum Screen: Hashable, Identifiable {
        case teamSelect
        case teamDetail(teamId: String)
        
        var id: String {
            switch self {
            case .teamSelect: return "teamSelect"
            case .teamDetail(let id): return "teamDetail-\(id)"
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
