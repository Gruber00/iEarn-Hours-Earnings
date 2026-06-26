import SwiftData

@Model
final class SettingsModel {
    var hourlyRate: Double
    var currency: String
    var defaultPause: Int

    init(hourlyRate: Double = 18.5, currency: String = "€", defaultPause: Int = 30) {
        self.hourlyRate = hourlyRate
        self.currency = currency
        self.defaultPause = defaultPause
    }
}
