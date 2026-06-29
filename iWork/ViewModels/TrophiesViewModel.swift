import Foundation

struct TrophiesViewModel {
    static func sortedBadges(_ badges: [AchievementBadge]) -> [AchievementBadge] {
        AchievementService.uniquePreferredBadges(from: badges)
    }

    static func totalEarnings(from entries: [WorkEntry]) -> Double {
        StatisticsCalculator.totalEarnings(entries)
    }

    static func progress(for badge: AchievementBadge, totalEarnings: Double) -> Double {
        guard badge.requiredAmount > 0 else { return 1 }
        return min(totalEarnings / badge.requiredAmount, 1)
    }

    static func title(for badge: AchievementBadge, language: AppLanguage) -> String {
        trophyKey(for: badge, suffix: "title").localized(language)
    }

    static func description(for badge: AchievementBadge, language: AppLanguage) -> String {
        trophyKey(for: badge, suffix: "description").localized(language)
    }

    static func progressText(for badge: AchievementBadge, totalEarnings: Double, currency: String, language: AppLanguage) -> String {
        "\(min(totalEarnings, badge.requiredAmount).formattedMoney(currency: currency, language: language)) / \(badge.requiredAmount.formattedMoney(currency: currency, language: language))"
    }

    static func statusText(for badge: AchievementBadge, language: AppLanguage) -> String {
        (badge.isUnlocked ? "trophies.unlocked" : "trophies.locked").localized(language)
    }

    static func unlockedDateText(for badge: AchievementBadge, language: AppLanguage) -> String? {
        guard let unlockedAt = badge.unlockedAt else { return nil }
        return "\("trophies.unlockedAt".localized(language)) \(unlockedAt.appDateTimeText(language: language))"
    }

    private static func trophyKey(for badge: AchievementBadge, suffix: String) -> String {
        switch Int(badge.requiredAmount) {
        case 100: "trophies.100.\(suffix)"
        case 500: "trophies.500.\(suffix)"
        case 1_000: "trophies.1000.\(suffix)"
        case 10_000: "trophies.10000.\(suffix)"
        case 20_000: "trophies.20000.\(suffix)"
        case 50_000: "trophies.50000.\(suffix)"
        default: suffix == "title" ? badge.title : badge.descriptionText
        }
    }
}
