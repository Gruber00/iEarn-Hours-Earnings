import SwiftUI

struct StatisticsView: View {
    let entries: [WorkEntry]
    let settings: SettingsModel
    let language: AppLanguage

    @State private var selectedMonth = Date()

    private var monthEntries: [WorkEntry] {
        StatisticsViewModel.monthEntries(from: entries, selectedMonth: selectedMonth)
    }

    private var dailySummaries: [DailySummary] {
        StatisticsViewModel.dailySummaries(from: monthEntries)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MonthStepper(selectedMonth: $selectedMonth, language: language)

                    ChartCard(title: "statistics.hoursPerDay".localized(language), symbol: "chart.xyaxis.line") {
                        HoursChart(data: dailySummaries, language: language)
                    }

                    ChartCard(title: "statistics.earningsPerDay".localized(language), symbol: "banknote.fill") {
                        EarningsChart(data: dailySummaries, currency: settings.currency, language: language)
                    }

                    VStack(spacing: 12) {
                        StatisticRow(title: "statistics.totalHours".localized(language), value: StatisticsViewModel.totalHours(for: monthEntries).appHoursAndMinutesText(language: language), symbol: "clock.fill")
                        StatisticRow(title: "statistics.totalEarnings".localized(language), value: StatisticsViewModel.totalEarnings(for: monthEntries).formattedMoney(currency: settings.currency, language: language), symbol: "banknote.fill")
                        StatisticRow(title: "statistics.averageHours".localized(language), value: StatisticsViewModel.averageHours(for: monthEntries).appDecimalHoursText(language: language), symbol: "chart.line.uptrend.xyaxis")
                        StatisticRow(title: "statistics.averageEarnings".localized(language), value: StatisticsViewModel.averageEarnings(for: monthEntries).formattedMoney(currency: settings.currency, language: language), symbol: "divide.circle.fill")
                        StatisticRow(title: "statistics.workDayCount".localized(language), value: "\(monthEntries.count)", symbol: "calendar")
                        StatisticRow(title: "statistics.longestDay".localized(language), value: StatisticsViewModel.longestDay(for: monthEntries).appDecimalHoursText(language: language), symbol: "timer")
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(AppBackground())
            .navigationTitle("statistics.title".localized(language))
        }
    }
}
