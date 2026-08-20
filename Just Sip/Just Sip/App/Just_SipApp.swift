import SwiftUI
import SwiftData

@main
struct Just_SipApp: App {

    @State private var showSplash = true

    var body: some Scene {

        WindowGroup {

            ZStack {

                // MARK: - Main App

                HomeView()
                    .opacity(showSplash ? 0 : 1)

                // MARK: - Splash Screen

                if showSplash {

                    SplashView {

                        withAnimation(
                            .easeInOut(duration: 0.5)
                        ) {
                            showSplash = false
                        }

                    }
                    .transition(.opacity)
                }
            }
        }
        .modelContainer(
            for: WaterEntry.self
        )
    }
}
