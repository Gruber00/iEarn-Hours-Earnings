import SwiftData

struct DatabaseManager {
    static func ensureSettingsExist(settings: [SettingsModel], in context: ModelContext) {
        guard settings.isEmpty else { return }
        context.insert(SettingsModel())
    }

    static func ensureAchievementBadgesExist(badges: [AchievementBadge], in context: ModelContext) {
        AchievementService.ensureDefaultBadgesExist(badges: badges, in: context)
    }
}
