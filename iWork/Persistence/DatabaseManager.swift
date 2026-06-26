import SwiftData

struct DatabaseManager {
    static func ensureSettingsExist(settings: [SettingsModel], in context: ModelContext) {
        guard settings.isEmpty else { return }
        context.insert(SettingsModel())
    }
}
