import Charts
import SwiftUI

struct DailyBarChart: View {
    let data: [DailySummary]
    let value: KeyPath<DailySummary, Double>
    let color: Color
    let label: String
    let language: AppLanguage
    let chartStyle: ChartStyle

    var body: some View {
        Chart(data) { item in
            switch chartStyle {
            case .bar:
                BarMark(
                    x: .value("statistics.dayAxis".localized(language), item.day),
                    y: .value(label, item[keyPath: value])
                )
                .foregroundStyle(color.gradient)
            case .line:
                LineMark(
                    x: .value("statistics.dayAxis".localized(language), item.day),
                    y: .value(label, item[keyPath: value])
                )
                .foregroundStyle(color)
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))

                PointMark(
                    x: .value("statistics.dayAxis".localized(language), item.day),
                    y: .value(label, item[keyPath: value])
                )
                .foregroundStyle(color)
                .symbolSize(36)
            }
        }
        .chartXAxis {
            AxisMarks(values: [1, 5, 10, 15, 20, 25, 31])
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 4))
        }
        .animation(.smooth, value: data)
        .animation(.smooth, value: chartStyle)
    }
}
