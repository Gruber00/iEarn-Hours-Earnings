import SwiftUI

struct MonthlySummaryView: View {
    let totalEarnings: Double
    let totalHours: Double
    let settings: SettingsModel

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 6) {
                Label("Verdienst", systemImage: "banknote.fill")
                    .font(.title.bold())
                    .foregroundStyle(.primary)

                Text(totalEarnings.formattedMoney(currency: settings.currency))
                    .font(.system(size: 60, weight: .heavy, design: .rounded))
                    .foregroundStyle(.green)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .contentTransition(.numericText())
            }

            HStack(spacing: 12) {
                SummaryMetric(
                    title: "Arbeitsstunden diesen Monat",
                    value: totalHours.appHoursAndMinutesText,
                    symbol: "clock.fill"
                )

                SummaryMetric(
                    title: "Stundenlohn",
                    value: settings.hourlyRate.formattedMoney(currency: settings.currency),
                    symbol: "dollarsign.circle.fill"
                )
            }
        }
        .padding(24)
        .surfaceCard(cornerRadius: 32)
        .animation(.smooth, value: totalEarnings)
        .animation(.smooth, value: totalHours)
    }
}
