import SwiftData

@Model
final class SettingsModel {
    var hourlyRate: Double
    var currency: String
    var defaultPause: Int
    var selectedLanguage: String = AppLanguage.english.languageCode
    var preferredHand: String = PreferredHand.left.rawValue
    var chartStyle: String = ChartStyle.bar.rawValue
    var accentColor: String = AppAccentColor.appleGreen.rawValue
    var monthlyGoalAmount: Double = GoalService.defaultGoalAmount
    var hasCompletedOnboarding: Bool = false

    init(
        hourlyRate: Double = 18.5,
        currency: String = "€",
        defaultPause: Int = 30,
        selectedLanguage: String = AppLanguage.english.languageCode,
        preferredHand: String = PreferredHand.left.rawValue,
        chartStyle: String = ChartStyle.bar.rawValue,
        accentColor: String = AppAccentColor.appleGreen.rawValue,
        monthlyGoalAmount: Double = GoalService.defaultGoalAmount,
        hasCompletedOnboarding: Bool = false
    ) {
        self.hourlyRate = hourlyRate
        self.currency = currency
        self.defaultPause = defaultPause
        self.selectedLanguage = selectedLanguage
        self.preferredHand = preferredHand
        self.chartStyle = chartStyle
        self.accentColor = accentColor
        self.monthlyGoalAmount = monthlyGoalAmount
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }

    var appLanguage: AppLanguage {
        AppLanguage(languageCode: selectedLanguage)
    }

    var preferredHandValue: PreferredHand {
        PreferredHand(storedValue: preferredHand)
    }

    var chartStyleValue: ChartStyle {
        ChartStyle(storedValue: chartStyle)
    }

    var accentColorValue: AppAccentColor {
        AppAccentColor(storedValue: accentColor)
    }
}
