import Foundation

struct DateHelper {
    static func monthTitle(_ date: Date) -> String {
        date.formatted(.dateTime.month(.wide).year())
    }

    static func dayTitle(_ date: Date) -> String {
        date.formatted(.dateTime.day().month(.wide))
    }

    static func dateAt(hour: Int, minute: Int, matching baseDate: Date = .now) -> Date {
        Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: baseDate) ?? baseDate
    }

    static func isInSameMonth(_ date: Date, as month: Date, calendar: Calendar = .current) -> Bool {
        calendar.isDate(date, equalTo: month, toGranularity: .month)
    }

    static func addingMonths(_ value: Int, to date: Date) -> Date {
        Calendar.current.date(byAdding: .month, value: value, to: date) ?? date
    }
}
