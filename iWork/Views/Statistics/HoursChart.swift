import Charts
import SwiftUI

struct HoursChart: View {
    let data: [DailySummary]
    let language: AppLanguage

    var body: some View {
        DailyBarChart(
            data: data,
            value: \.hours,
            color: .green,
            label: "statistics.hoursAxis".localized(language),
            language: language
        )
    }
}
