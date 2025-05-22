import Combine
import SwiftData
import SwiftUI

struct SplashViewModel {
    let imageAssetName: String
    let duration: TimeInterval
}

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

#if DEBUG
extension SplashViewModel {
    static func make(
        imageAssetName: String = "SuperSoccerLaunch",
        duration: TimeInterval = 1.0
    ) -> Self {
        self.init(
            imageAssetName: imageAssetName,
            duration: duration
        )
    }
}
#endif
