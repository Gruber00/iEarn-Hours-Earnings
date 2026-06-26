import SwiftUI

struct MonthlySummaryView: View {
    let totalEarnings: Double
    let totalHours: Double
    let settings: SettingsModel
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 6) {
                Label("home.earnings".localized(language), systemImage: "banknote.fill")
                    .font(.title.bold())
                    .foregroundStyle(.primary)

                Text(totalEarnings.formattedMoney(currency: settings.currency, language: language))
                    .font(.system(size: 60, weight: .heavy, design: .rounded))
                    .foregroundStyle(.green)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .contentTransition(.numericText())
            }

            HStack(spacing: 12) {
                SummaryMetric(
                    title: "home.monthHours".localized(language),
                    value: totalHours.appHoursAndMinutesText(language: language),
                    symbol: "clock.fill"
                )

                SummaryMetric(
                    title: "home.hourlyRate".localized(language),
                    value: settings.hourlyRate.formattedMoney(currency: settings.currency, language: language),
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
