import Foundation
import SwiftData

@Model
final class AchievementBadge {
    @Attribute(.unique) var id: UUID
    var title: String
    var descriptionText: String
    var requiredAmount: Double
    var symbolName: String
    var unlockedAt: Date?
    var isUnlocked: Bool

    init(
        id: UUID = UUID(),
        title: String,
        descriptionText: String,
        requiredAmount: Double,
        symbolName: String,
        unlockedAt: Date? = nil,
        isUnlocked: Bool = false
    ) {
        self.id = id
        self.title = title
        self.descriptionText = descriptionText
        self.requiredAmount = requiredAmount
        self.symbolName = symbolName
        self.unlockedAt = unlockedAt
        self.isUnlocked = isUnlocked
    }
}
