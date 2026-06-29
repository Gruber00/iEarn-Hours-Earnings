import SwiftUI

struct ChartTooltipView: View {
    let summary: DailySummary
    let date: Date
    let currency: String
    let share: Double
    let language: AppLanguage

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(date.appDayTitle(language: language))
                .font(.caption.weight(.bold))

            Text(summary.hours.appDecimalHoursText(language: language))
                .font(.caption)

            Text(summary.earnings.formattedMoney(currency: currency, language: language))
                .font(.caption.weight(.semibold))
                .foregroundStyle(accentColor)

            Text("\("chart.monthShare".localized(language)): \(share.formatted(.percent.precision(.fractionLength(0))))")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.18), radius: 16, y: 8)
    }
}
