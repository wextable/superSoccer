import SwiftUI
import Combine

@MainActor
final class NavigationRouter: ObservableObject {
    @Published var path = NavigationPath()
    @Published var screens: [Screen] = []
    @Published var presentedSheet: Screen?
    
    enum Screen: Hashable, Identifiable {
        case splash
        case mainMenu(presenter: MainMenuViewPresenter)
        case newGame(presenter: NewGameViewPresenter)
        case teamSelect(presenter: TeamSelectViewPresenter)
        case team(interactor: TeamInteractorProtocol)
        case tabContainer(tabs: [TabConfiguration])
        
        var id: String {
            switch self {
            case .splash: return "splash"
            case .mainMenu: return "mainMenu"
            case .newGame: return "newGame"
            case .teamSelect: return "teamSelect"
            case .team: return "team"
            case .tabContainer: return "tabContainer"
            }
        }
        
        static func == (lhs: Screen, rhs: Screen) -> Bool {
            switch (lhs, rhs) {
            case (.splash, .splash): return true
            case (.mainMenu, .mainMenu): return true
            case (.newGame, .newGame): return true
            case (.teamSelect, .teamSelect): return true
            case (.team, .team): return true
            case (.tabContainer, .tabContainer): return true
            default: return false
            }
        }
        
        func hash(into hasher: inout Hasher) {
            switch self {
            case .splash:
                hasher.combine("splash")
            case .mainMenu(let presenter):
                hasher.combine("mainMenu")
                hasher.combine(ObjectIdentifier(presenter))
            case .newGame(let presenter):
                hasher.combine("newGame")
                hasher.combine(ObjectIdentifier(presenter))
            case .teamSelect(let presenter):
                hasher.combine("teamSelect")
                hasher.combine(ObjectIdentifier(presenter))
            case .team(let interactor):
                hasher.combine("team")
                hasher.combine(ObjectIdentifier(interactor))
            case .tabContainer(let tabs):
                hasher.combine("tabContainer")
                hasher.combine(tabs)
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
        switch screen {
        case .splash, .mainMenu:
            path = NavigationPath()
            screens = [screen]
        default:
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
