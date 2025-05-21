import Combine
import SwiftData
import SwiftUI

struct SplashView<Interactor: SplashViewInteractorProtocol>: View {
    let interactor: Interactor
    @State private var isActive = false
    
    var body: some View {
        Image("SuperSoccerLaunch")
            .resizable()
            .scaledToFit()
            .ignoresSafeArea()
            .task {
                try? await Task.sleep(for: .seconds(interactor.viewModel.duration))
                if !isActive {
                    isActive = true
                    interactor.eventBus.send(.finished)
                }
            }
    }
}

struct SplashViewModel {
    let imageAssetName: String
    let duration: TimeInterval
}

//#Preview {
//    SplashView() {
//        print("done")
//    }
//}
