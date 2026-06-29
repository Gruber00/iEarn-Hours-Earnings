import Foundation
import Observation

@Observable
final class MonthSelectionViewModel {
    private let calendar: Calendar

    var selectedMonth: Date

    var selectedYear: Int {
        calendar.component(.year, from: selectedMonth)
    }

    var currentMonth: Date {
        Self.startOfMonth(for: .now, calendar: calendar)
    }

    init(selectedMonth: Date = .now, calendar: Calendar = .current) {
        self.calendar = calendar
        self.selectedMonth = Self.startOfMonth(for: selectedMonth, calendar: calendar)
    }

    func select(_ month: Date) {
        selectedMonth = Self.startOfMonth(for: month, calendar: calendar)
    }

    func moveByMonths(_ value: Int) {
        let nextMonth = calendar.date(byAdding: .month, value: value, to: selectedMonth) ?? selectedMonth
        select(nextMonth)
    }

    private static func startOfMonth(for date: Date, calendar: Calendar) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? date
    }
}
