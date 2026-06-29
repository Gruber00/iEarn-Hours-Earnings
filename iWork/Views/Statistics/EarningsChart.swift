import SwiftUI

struct EarningsChart: View {
    let data: [DailySummary]
    let currency: String
    let language: AppLanguage
    let chartStyle: ChartStyle

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        DailyBarChart(
            data: data,
            value: \.earnings,
            color: accentColor,
            label: currency,
            language: language,
            chartStyle: chartStyle
        )
    }
}
