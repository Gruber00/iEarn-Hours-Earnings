import SwiftUI

struct StatisticsView: View {
    let entries: [WorkEntry]
    let settings: SettingsModel
    let language: AppLanguage
    let monthSelection: MonthSelectionViewModel

    @State private var showingGoalDetails = false
    @State private var selectedChartMetric: StatisticsChartMetric?

    private var selectedMonth: Binding<Date> {
        Binding(
            get: { monthSelection.selectedMonth },
            set: { monthSelection.select($0) }
        )
    }

    var body: some View {
        let selectedMonthValue = monthSelection.selectedMonth
        let snapshot = StatisticsViewModel.snapshot(entries: entries, selectedMonth: selectedMonthValue, settings: settings)

        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    MonthStepper(selectedMonth: selectedMonth, language: language)

                    GoalPieChart(
                        progress: snapshot.goalProgress,
                        segments: snapshot.goalSegments,
                        currency: settings.currency,
                        language: language
                    ) {
                        showingGoalDetails = true
                    }

                    Button {
                        selectedChartMetric = .hours
                    } label: {
                        ChartCard(title: "statistics.hoursPerDay".localized(language), symbol: "chart.xyaxis.line", tapHint: "chart.tapToEnlarge".localized(language)) {
                            HoursChart(data: snapshot.dailySummaries, language: language, chartStyle: settings.chartStyleValue)
                        }
                    }
                    .buttonStyle(.plain)

                    Button {
                        selectedChartMetric = .earnings
                    } label: {
                        ChartCard(title: "statistics.earningsPerDay".localized(language), symbol: "banknote.fill", tapHint: "chart.tapToEnlarge".localized(language)) {
                            EarningsChart(data: snapshot.dailySummaries, currency: settings.currency, language: language, chartStyle: settings.chartStyleValue)
                        }
                    }
                    .buttonStyle(.plain)

                    VStack(spacing: 12) {
                        StatisticRow(title: "statistics.totalHours".localized(language), value: snapshot.totalHours.appHoursAndMinutesText(language: language), symbol: "clock.fill")
                        StatisticRow(title: "statistics.totalEarnings".localized(language), value: snapshot.totalEarnings.formattedMoney(currency: settings.currency, language: language), symbol: "banknote.fill")
                        StatisticRow(title: "statistics.averageHours".localized(language), value: snapshot.averageHours.appDecimalHoursText(language: language), symbol: "chart.line.uptrend.xyaxis")
                        StatisticRow(title: "statistics.averageEarnings".localized(language), value: snapshot.averageEarnings.formattedMoney(currency: settings.currency, language: language), symbol: "divide.circle.fill")
                        StatisticRow(title: "statistics.workDayCount".localized(language), value: "\(snapshot.workDayCount)", symbol: "calendar")
                        StatisticRow(title: "statistics.longestDay".localized(language), value: snapshot.longestDay.appDecimalHoursText(language: language), symbol: "timer")
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(AppBackground())
            .navigationTitle("statistics.title".localized(language))
            .sheet(isPresented: $showingGoalDetails) {
                GoalPieChartDetailSheet(
                    progress: snapshot.goalProgress,
                    segments: snapshot.goalSegments,
                    dailyShares: snapshot.dailyShares,
                    currency: settings.currency,
                    language: language
                )
                .environment(\.locale, language.locale)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.thinMaterial)
            }
            .sheet(item: $selectedChartMetric) { metric in
                StatisticsChartDetailView(
                    viewModel: StatisticsChartViewModel(
                        metric: metric,
                        data: snapshot.dailySummaries,
                        selectedMonth: selectedMonthValue,
                        settings: settings,
                        language: language
                    )
                )
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.thinMaterial)
            }
        }
    }
}
