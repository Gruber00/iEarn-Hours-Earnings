import SwiftData

struct SwiftDataContainer {
    static let schema: [any PersistentModel.Type] = [
        WorkEntry.self,
        SettingsModel.self,
        AchievementBadge.self
    ]
}
