import SwiftData
import SwiftUI

enum OnboardingResetService {
    @MainActor
    static func restartOnboarding(settings: SettingsModel, context: ModelContext) {
        withAnimation(.smooth) {
            settings.hasCompletedOnboarding = false
        }

        try? context.save()
    }
}
