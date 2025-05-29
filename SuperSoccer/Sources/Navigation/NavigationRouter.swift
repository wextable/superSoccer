import SwiftUI
import Combine

final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var screens: [Screen] = []
    @Published var presentedSheet: Screen?
    
    enum Screen: Hashable, Identifiable {
        case splash
        case mainMenu
        case newGame
        case teamSelect
        
        var id: String {
            switch self {
            case .splash: return "splash"
            case .mainMenu: return "mainMenu"
            case .newGame: return "newGame"
            case .teamSelect: return "teamSelect"
            }
        }
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.splash, .splash): return true
            case (.mainMenu, .mainMenu): return true
            case (.newGame, .newGame): return true
            case (.teamSelect, .teamSelect): return true
            default: return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .splash:
                hasher.combine("splash")
            case .mainMenu:
                hasher.combine("mainMenu")
            case .newGame:
                hasher.combine("newGame")
            case .teamSelect:
                hasher.combine("teamSelect")
            }
        }
    }
    
    func navigate(to screen: Screen) {
        path.append(screen)
        screens.append(screen)
    }
    
    func replaceNavigationStack(with screen: Screen) {
        // For root-level screens (splash, mainMenu), set them as the base screen
        // and clear the navigation path
        if screen == .splash || screen == .mainMenu {
            path = NavigationPath()
            screens = [screen]
        } else {
            // For other screens, they should be in the navigation path
            path = NavigationPath([screen])
            screens = [screen]
        }
    }
    
    func popToRoot() {
        path = NavigationPath()
        screens = []
    }
    
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
        if !screens.isEmpty {
            screens.removeLast()
        }
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
}
