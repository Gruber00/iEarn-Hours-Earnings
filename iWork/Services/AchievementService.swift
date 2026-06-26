import Foundation
import SwiftData

struct AchievementService {
    static let defaultBadges: [AchievementTemplate] = [
        AchievementTemplate(
            title: "100 € erreicht",
            descriptionText: "Du hast insgesamt 100 € verdient.",
            requiredAmount: 100,
            symbolName: "banknote.fill"
        ),
        AchievementTemplate(
            title: "500 € erreicht",
            descriptionText: "Du hast insgesamt 500 € verdient.",
            requiredAmount: 500,
            symbolName: "dollarsign.circle.fill"
        ),
        AchievementTemplate(
            title: "1.000 € erreicht",
            descriptionText: "Du hast insgesamt 1.000 € verdient.",
            requiredAmount: 1_000,
            symbolName: "trophy.fill"
        )
    ]

    static func ensureDefaultBadgesExist(badges: [AchievementBadge], in context: ModelContext) {
        for template in defaultBadges where !badges.contains(where: { $0.requiredAmount == template.requiredAmount }) {
            context.insert(
                AchievementBadge(
                    title: template.title,
                    descriptionText: template.descriptionText,
                    requiredAmount: template.requiredAmount,
                    symbolName: template.symbolName
                )
            )
        }
    }

    static func evaluateBadges(entries: [WorkEntry], badges: [AchievementBadge], now: Date = .now) {
        let totalEarnings = StatisticsCalculator.totalEarnings(entries)

        for badge in badges where totalEarnings >= badge.requiredAmount && !badge.isUnlocked {
            badge.isUnlocked = true
            badge.unlockedAt = now
        }
    }
}

struct AchievementTemplate {
    let title: String
    let descriptionText: String
    let requiredAmount: Double
    let symbolName: String
}
