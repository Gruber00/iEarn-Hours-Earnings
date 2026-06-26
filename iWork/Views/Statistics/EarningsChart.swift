import Charts
import SwiftUI

struct EarningsChart: View {
    let data: [DailySummary]
    let currency: String

    var body: some View {
        DailyBarChart(data: data, value: \.earnings, color: .blue, label: currency)
    }
}
