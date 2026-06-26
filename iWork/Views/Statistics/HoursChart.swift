import Charts
import SwiftUI

struct HoursChart: View {
    let data: [DailySummary]

    var body: some View {
        DailyBarChart(data: data, value: \.hours, color: .green, label: "Stunden")
    }
}
