import SwiftUI

struct EarningsCard: View {
    let totalEarnings: Double
    let totalHours: Double
    let settings: SettingsModel
    let language: AppLanguage

    var body: some View {
        MonthlySummaryView(
            totalEarnings: totalEarnings,
            totalHours: totalHours,
            settings: settings,
            language: language
        )
    }
}
