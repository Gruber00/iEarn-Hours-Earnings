import SwiftUI

enum StatisticsChartMetric: String, Identifiable {
    case hours
    case earnings

    var id: String { rawValue }

    var titleKey: String {
        switch self {
        case .hours:
            "statistics.hoursPerDay"
        case .earnings:
            "statistics.earningsPerDay"
        }
    }

    var symbolName: String {
        switch self {
        case .hours:
            "chart.xyaxis.line"
        case .earnings:
            "banknote.fill"
        }
    }

    func color(accentColor: Color) -> Color {
        accentColor
    }

    func value(from summary: DailySummary) -> Double {
        switch self {
        case .hours:
            summary.hours
        case .earnings:
            summary.earnings
        }
    }

    func axisLabel(currency: String, language: AppLanguage) -> String {
        switch self {
        case .hours:
            "statistics.hoursAxis".localized(language)
        case .earnings:
            currency
        }
    }
}

struct StatisticsChartViewModel {
    let metric: StatisticsChartMetric
    let data: [DailySummary]
    let selectedMonth: Date
    let settings: SettingsModel
    let language: AppLanguage

    var chartStyle: ChartStyle {
        settings.chartStyleValue
    }

    var title: String {
        metric.titleKey.localized(language)
    }

    var axisLabel: String {
        metric.axisLabel(currency: settings.currency, language: language)
    }

    func selectedSummary(for day: Int?) -> DailySummary? {
        ChartInteractionService.summary(for: day, in: data)
    }

    func date(for summary: DailySummary) -> Date {
        ChartInteractionService.date(for: summary.day, in: selectedMonth)
    }

    func earningsShare(for summary: DailySummary) -> Double {
        ChartInteractionService.earningsShare(for: summary, in: data)
    }
}
