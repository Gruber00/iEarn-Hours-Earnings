import SwiftUI

struct HoursChart: View {
    let data: [DailySummary]
    let language: AppLanguage
    let chartStyle: ChartStyle

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        DailyBarChart(
            data: data,
            value: \.hours,
            color: accentColor,
            label: "statistics.hoursAxis".localized(language),
            language: language,
            chartStyle: chartStyle
        )
    }
}
