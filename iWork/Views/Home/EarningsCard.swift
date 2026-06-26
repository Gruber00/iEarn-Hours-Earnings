import SwiftUI

struct EarningsCard: View {
    let totalEarnings: Double
    let totalHours: Double
    let settings: SettingsModel

    var body: some View {
        MonthlySummaryView(totalEarnings: totalEarnings, totalHours: totalHours, settings: settings)
    }
}
