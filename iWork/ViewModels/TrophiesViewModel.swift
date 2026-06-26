import Foundation

struct TrophiesViewModel {
    static func sortedBadges(_ badges: [AchievementBadge]) -> [AchievementBadge] {
        badges.sorted { $0.requiredAmount < $1.requiredAmount }
    }

    static func totalEarnings(from entries: [WorkEntry]) -> Double {
        StatisticsCalculator.totalEarnings(entries)
    }

    static func progress(for badge: AchievementBadge, totalEarnings: Double) -> Double {
        guard badge.requiredAmount > 0 else { return 1 }
        return min(totalEarnings / badge.requiredAmount, 1)
    }

    static func progressText(for badge: AchievementBadge, totalEarnings: Double, currency: String) -> String {
        "\(min(totalEarnings, badge.requiredAmount).formattedMoney(currency: currency)) / \(badge.requiredAmount.formattedMoney(currency: currency))"
    }

    static func statusText(for badge: AchievementBadge) -> String {
        badge.isUnlocked ? "Freigeschaltet" : "Noch nicht freigeschaltet"
    }

    static func unlockedDateText(for badge: AchievementBadge) -> String? {
        guard let unlockedAt = badge.unlockedAt else { return nil }
        return "Freigeschaltet am " + unlockedAt.formatted(.dateTime.day().month().year().hour().minute())
    }
}
