import Charts
import SwiftUI

struct OnboardingChartStyleView: View {
    @Binding var chartStyle: String
    let language: AppLanguage

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingHeader(
                symbol: "chart.xyaxis.line",
                title: "chart.style".localized(language),
                subtitle: "chart.statisticsView".localized(language)
            )

            VStack(spacing: 14) {
                ForEach(ChartStyle.allCases) { style in
                    chartStyleButton(for: style)
                }
            }
        }
    }

    private func chartStyleButton(for style: ChartStyle) -> some View {
        Button {
            withAnimation(.snappy) {
                chartStyle = style.rawValue
            }
        } label: {
            HStack(spacing: 16) {
                MiniChartPreview(style: style)
                    .frame(width: 96, height: 64)

                VStack(alignment: .leading, spacing: 6) {
                    Text(style.displayKey.localized(language))
                        .font(.headline)
                    Text(style.descriptionKey.localized(language))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer()

                if chartStyle == style.rawValue {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(accentColor)
                        .symbolEffect(.bounce, value: chartStyle)
                }
            }
            .padding(16)
            .surfaceCard(cornerRadius: 20)
        }
        .buttonStyle(.plain)
    }
}

private struct MiniChartPreview: View {
    let style: ChartStyle
    @Environment(\.appAccentColor) private var accentColor
    private let points = [
        MiniChartPoint(day: 1, value: 2.0),
        MiniChartPoint(day: 2, value: 5.0),
        MiniChartPoint(day: 3, value: 3.4),
        MiniChartPoint(day: 4, value: 7.2),
        MiniChartPoint(day: 5, value: 5.8)
    ]

    var body: some View {
        Chart(points) { point in
            switch style {
            case .bar:
                BarMark(
                    x: .value("Day", point.day),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(accentColor.gradient)
            case .line:
                LineMark(
                    x: .value("Day", point.day),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(accentColor)
                .interpolationMethod(.catmullRom)

                PointMark(
                    x: .value("Day", point.day),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(accentColor)
                .symbolSize(26)
            }
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .padding(8)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct MiniChartPoint: Identifiable {
    let day: Int
    let value: Double

    var id: Int { day }
}
