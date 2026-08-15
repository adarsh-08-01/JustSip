import SwiftUI
import SwiftData

@main
struct JustSipApp: App {
    var body: some Scene{
        WindowGroup{
            HomeView()
        }
        .modelContainer(for: WaterEntry.self)
    }
}
