import SwiftData

@Model
final class SettingsModel {
    var hourlyRate: Double
    var currency: String
    var defaultPause: Int
    var selectedLanguage: String = AppLanguage.german.languageCode
    var preferredHand: String = PreferredHand.left.rawValue
    var monthlyGoalAmount: Double = GoalService.defaultGoalAmount

    init(
        hourlyRate: Double = 18.5,
        currency: String = "€",
        defaultPause: Int = 30,
        selectedLanguage: String = AppLanguage.german.languageCode,
        preferredHand: String = PreferredHand.left.rawValue,
        monthlyGoalAmount: Double = GoalService.defaultGoalAmount
    ) {
        self.hourlyRate = hourlyRate
        self.currency = currency
        self.defaultPause = defaultPause
        self.selectedLanguage = selectedLanguage
        self.preferredHand = preferredHand
        self.monthlyGoalAmount = monthlyGoalAmount
    }

    var appLanguage: AppLanguage {
        AppLanguage(languageCode: selectedLanguage)
    }

    var preferredHandValue: PreferredHand {
        PreferredHand(storedValue: preferredHand)
    }
}
