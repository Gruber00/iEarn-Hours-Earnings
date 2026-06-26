import SwiftData

@Model
final class SettingsModel {
    var hourlyRate: Double
    var currency: String
    var defaultPause: Int
    var selectedLanguage: String = AppLanguage.german.languageCode

    init(
        hourlyRate: Double = 18.5,
        currency: String = "€",
        defaultPause: Int = 30,
        selectedLanguage: String = AppLanguage.german.languageCode
    ) {
        self.hourlyRate = hourlyRate
        self.currency = currency
        self.defaultPause = defaultPause
        self.selectedLanguage = selectedLanguage
    }

    var appLanguage: AppLanguage {
        AppLanguage(languageCode: selectedLanguage)
    }
}
