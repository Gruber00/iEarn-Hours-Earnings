import Foundation

struct SettingsViewModel {
    static let currencies = ["€", "$", "£", "CHF", "¥"]
    static let pauseOptions = [0, 15, 30, 45, 60]

    static func updateHourlyRate(from text: String, settings: SettingsModel, entries: [WorkEntry]) {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        guard let hourlyRate = Double(normalized), hourlyRate >= 0, hourlyRate != settings.hourlyRate else { return }

        settings.hourlyRate = hourlyRate
        entries.forEach { $0.recalculate(hourlyRate: hourlyRate) }
    }

    static func updateMonthlyGoal(from text: String, settings: SettingsModel) {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        guard let amount = Double(normalized), amount.isFinite, amount >= 0 else { return }
        settings.monthlyGoalAmount = amount > 0 ? amount : GoalService.defaultGoalAmount
    }
}
