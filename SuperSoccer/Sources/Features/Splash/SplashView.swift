import Combine
import SwiftData
import SwiftUI

struct SplashViewModel {
    let imageAssetName: String
}

struct SplashView: View {
    
    var body: some View {
        Image("SuperSoccerLaunch")
            .resizable()
            .scaledToFit()
            .ignoresSafeArea()
    }
}

#if DEBUG
extension SplashViewModel {
    static func make(
        imageAssetName: String = "SuperSoccerLaunch"
    ) -> Self {
        self.init(
            imageAssetName: imageAssetName
        )
    }
}
#endif
