import Charts
import SwiftUI

struct EarningsChart: View {
    let data: [DailySummary]
    let currency: String
    let language: AppLanguage

    var body: some View {
        DailyBarChart(data: data, value: \.earnings, color: .blue, label: currency, language: language)
    }
}
