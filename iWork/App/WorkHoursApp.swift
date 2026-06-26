import SwiftData
import SwiftUI

@main
struct WorkHoursApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SwiftDataContainer.schema)
    }
}
