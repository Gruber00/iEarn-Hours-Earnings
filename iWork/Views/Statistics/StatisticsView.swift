import SwiftUI

struct StatisticsView: View {
    let entries: [WorkEntry]
    let settings: SettingsModel

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
                    MonthStepper(selectedMonth: $selectedMonth)

                    ChartCard(title: "Arbeitsstunden pro Tag", symbol: "chart.xyaxis.line") {
                        HoursChart(data: dailySummaries)
                    }

                    ChartCard(title: "Verdienst pro Tag", symbol: "banknote.fill") {
                        EarningsChart(data: dailySummaries, currency: settings.currency)
                    }

                    VStack(spacing: 12) {
                        StatisticRow(title: "Gesamtstunden", value: StatisticsViewModel.totalHours(for: monthEntries).appHoursAndMinutesText, symbol: "clock.fill")
                        StatisticRow(title: "Gesamtverdienst", value: StatisticsViewModel.totalEarnings(for: monthEntries).formattedMoney(currency: settings.currency), symbol: "banknote.fill")
                        StatisticRow(title: "Durchschnitt Stunden", value: StatisticsViewModel.averageHours(for: monthEntries).appDecimalHoursText, symbol: "chart.line.uptrend.xyaxis")
                        StatisticRow(title: "Durchschnitt Verdienst", value: StatisticsViewModel.averageEarnings(for: monthEntries).formattedMoney(currency: settings.currency), symbol: "divide.circle.fill")
                        StatisticRow(title: "Anzahl Arbeitstage", value: "\(monthEntries.count)", symbol: "calendar")
                        StatisticRow(title: "Längster Arbeitstag", value: StatisticsViewModel.longestDay(for: monthEntries).appDecimalHoursText, symbol: "timer")
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(AppBackground())
            .navigationTitle("Statistik")
        }
    }
}
