import Charts
import SwiftUI

struct StatisticsChartDetailView: View {
    let viewModel: StatisticsChartViewModel
    @State private var selectedDay: Int?
    @Environment(\.appAccentColor) private var accentColor

    private var selectedSummary: DailySummary? {
        viewModel.selectedSummary(for: selectedDay)
    }

    private var daysInMonth: Int {
        ChartInteractionService.daysInMonth(for: viewModel.selectedMonth)
    }

    private var xAxisValues: [Int] {
        ChartInteractionService.axisValues(forDaysInMonth: daysInMonth)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    GeometryReader { geometry in
                        chart(availableWidth: geometry.size.width)
                            .frame(width: geometry.size.width, height: 360)
                    }
                    .frame(height: 388)
                    .padding(16)
                    .surfaceCard(cornerRadius: 30)
                    .scaleEffect(selectedSummary == nil ? 1 : 1.01)
                    .animation(.spring(response: 0.35, dampingFraction: 0.82), value: selectedDay)
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(AppBackground())
            .navigationTitle(viewModel.title)
            .navigationBarTitleDisplayMode(.inline)
        }
        .environment(\.locale, viewModel.language.locale)
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(viewModel.title, systemImage: viewModel.metric.symbolName)
                .font(.title2.bold())
                .foregroundStyle(viewModel.metric.color(accentColor: accentColor))
                .symbolRenderingMode(.hierarchical)

            Text("chart.tapToEnlarge".localized(viewModel.language))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private func chart(availableWidth: CGFloat) -> some View {
        let markWidth = max(3, min(12, availableWidth / CGFloat(daysInMonth) * 0.46))
        let pointSize = daysInMonth > 30 ? 36.0 : 46.0
        let selectedPointSize = daysInMonth > 30 ? 82.0 : 104.0

        return Chart(viewModel.data) { item in
            switch viewModel.chartStyle {
            case .bar:
                BarMark(
                    x: .value("statistics.dayAxis".localized(viewModel.language), item.day),
                    y: .value(viewModel.axisLabel, viewModel.metric.value(from: item)),
                    width: .fixed(markWidth)
                )
                .foregroundStyle(selectedDay == item.day ? viewModel.metric.color(accentColor: accentColor) : viewModel.metric.color(accentColor: accentColor).opacity(0.55))
            case .line:
                LineMark(
                    x: .value("statistics.dayAxis".localized(viewModel.language), item.day),
                    y: .value(viewModel.axisLabel, viewModel.metric.value(from: item))
                )
                .foregroundStyle(viewModel.metric.color(accentColor: accentColor))
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 3, lineCap: .round, lineJoin: .round))

                PointMark(
                    x: .value("statistics.dayAxis".localized(viewModel.language), item.day),
                    y: .value(viewModel.axisLabel, viewModel.metric.value(from: item))
                )
                .foregroundStyle(selectedDay == item.day ? .primary : viewModel.metric.color(accentColor: accentColor))
                .symbolSize(selectedDay == item.day ? selectedPointSize : pointSize)
            }

            if selectedDay == item.day {
                RuleMark(x: .value("statistics.dayAxis".localized(viewModel.language), item.day))
                    .foregroundStyle(viewModel.metric.color(accentColor: accentColor).opacity(0.28))
                    .lineStyle(.init(lineWidth: 2, dash: [5, 5]))
            }
        }
        .chartXScale(domain: 1...daysInMonth)
        .chartXAxis {
            AxisMarks(values: xAxisValues) { value in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 5))
        }
        .chartXSelection(value: $selectedDay)
        .chartOverlay { proxy in
            GeometryReader { geometry in
                if let selectedSummary, let plotAnchor = proxy.plotFrame {
                    let plotFrame = geometry[plotAnchor]
                    let xPosition = proxy.position(forX: selectedSummary.day) ?? 0
                    let yPosition = proxy.position(forY: viewModel.metric.value(from: selectedSummary)) ?? 0
                    let proposedX = plotFrame.origin.x + xPosition
                    let clampedX = min(max(proposedX, 92), geometry.size.width - 92)

                    ChartTooltipView(
                        summary: selectedSummary,
                        date: viewModel.date(for: selectedSummary),
                        currency: viewModel.settings.currency,
                        share: viewModel.earningsShare(for: selectedSummary),
                        language: viewModel.language
                    )
                    .position(
                        x: clampedX,
                        y: max(plotFrame.origin.y + yPosition - 74, 58)
                    )
                    .transition(.scale(scale: 0.88).combined(with: .opacity))
                }
            }
        }
        .animation(.smooth, value: viewModel.data)
        .animation(.spring(response: 0.32, dampingFraction: 0.78), value: selectedDay)
    }
}
