import Foundation
import SwiftData

@MainActor
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
        ),
        AchievementTemplate(
            title: "10.000 € erreicht",
            descriptionText: "Du hast insgesamt 10.000 € verdient.",
            requiredAmount: 10_000,
            symbolName: "star.circle.fill"
        ),
        AchievementTemplate(
            title: "20.000 € erreicht",
            descriptionText: "Du hast insgesamt 20.000 € verdient.",
            requiredAmount: 20_000,
            symbolName: "crown.fill"
        ),
        AchievementTemplate(
            title: "50.000 € erreicht",
            descriptionText: "Du hast insgesamt 50.000 € verdient.",
            requiredAmount: 50_000,
            symbolName: "diamond.fill"
        )
    ]

    static func ensureDefaultBadgesExist(badges: [AchievementBadge], in context: ModelContext) {
        let remainingBadges = removeDuplicateBadges(badges: badges, in: context)
        let existingAmounts = Set(remainingBadges.map { normalizedAmount($0.requiredAmount) })

        for template in defaultBadges where !existingAmounts.contains(normalizedAmount(template.requiredAmount)) {
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

    @discardableResult
    static func removeDuplicateBadges(badges: [AchievementBadge], in context: ModelContext) -> [AchievementBadge] {
        let groupedBadges = Dictionary(grouping: badges) { normalizedAmount($0.requiredAmount) }
        var keptBadges: [AchievementBadge] = []

        for group in groupedBadges.values {
            guard let badgeToKeep = preferredBadgeToKeep(from: group) else { continue }
            keptBadges.append(badgeToKeep)

            for duplicate in group where duplicate.id != badgeToKeep.id {
                context.delete(duplicate)
            }
        }

        return keptBadges
    }

    static func evaluateBadges(entries: [WorkEntry], badges: [AchievementBadge], now: Date = .now) {
        let totalEarnings = StatisticsCalculator.totalEarnings(entries)
        let uniqueBadges = uniquePreferredBadges(from: badges)

        for badge in uniqueBadges where totalEarnings >= badge.requiredAmount && !badge.isUnlocked {
            badge.isUnlocked = true
            if badge.unlockedAt == nil {
                badge.unlockedAt = now
            }
        }
    }

    static func uniquePreferredBadges(from badges: [AchievementBadge]) -> [AchievementBadge] {
        Dictionary(grouping: badges) { normalizedAmount($0.requiredAmount) }
            .values
            .compactMap(preferredBadgeToKeep)
            .sorted { $0.requiredAmount < $1.requiredAmount }
    }

    private static func preferredBadgeToKeep(from badges: [AchievementBadge]) -> AchievementBadge? {
        badges.sorted { first, second in
            switch (first.isUnlocked, second.isUnlocked) {
            case (true, false):
                return true
            case (false, true):
                return false
            default:
                switch (first.unlockedAt, second.unlockedAt) {
                case let (firstDate?, secondDate?):
                    return firstDate < secondDate
                case (_?, nil):
                    return true
                case (nil, _?):
                    return false
                case (nil, nil):
                    return first.id.uuidString < second.id.uuidString
                }
            }
        }.first
    }

    private static func normalizedAmount(_ amount: Double) -> Int {
        Int(amount.rounded())
    }
}

struct AchievementTemplate {
    let title: String
    let descriptionText: String
    let requiredAmount: Double
    let symbolName: String
}
