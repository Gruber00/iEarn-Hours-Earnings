import Foundation

struct ChartInteractionService {
    static func summary(for selectedDay: Int?, in data: [DailySummary]) -> DailySummary? {
        guard let selectedDay else { return nil }
        return data.first { $0.day == selectedDay }
    }

    static func date(for day: Int, in selectedMonth: Date) -> Date {
        var components = Calendar.current.dateComponents([.year, .month], from: selectedMonth)
        components.day = day
        return Calendar.current.date(from: components) ?? selectedMonth
    }

    static func daysInMonth(for selectedMonth: Date) -> Int {
        Calendar.current.range(of: .day, in: .month, for: selectedMonth)?.count ?? 31
    }

    static func axisValues(forDaysInMonth daysInMonth: Int) -> [Int] {
        let baseValues = [1, 5, 10, 15, 20, 25]
        return (baseValues + [daysInMonth])
            .filter { $0 <= daysInMonth }
            .reduce(into: []) { values, day in
                if !values.contains(day) {
                    values.append(day)
                }
            }
    }

    static func earningsShare(for summary: DailySummary, in data: [DailySummary]) -> Double {
        let total = data.reduce(0) { $0 + $1.earnings }
        guard total > 0, total.isFinite else { return 0 }
        return summary.earnings / total
    }
}
