import Foundation

struct DateHelper {
    static func monthTitle(_ date: Date, language: AppLanguage) -> String {
        date.formatted(
            .dateTime
                .month(.wide)
                .year()
                .locale(language.locale)
        )
    }

    static func dayTitle(_ date: Date, language: AppLanguage) -> String {
        date.formatted(
            .dateTime
                .day()
                .month(.wide)
                .locale(language.locale)
        )
    }

    static func dateTimeText(_ date: Date, language: AppLanguage) -> String {
        switch language {
        case .german:
            date.formatted(.dateTime.day().month(.twoDigits).year().hour(.twoDigits(amPM: .omitted)).minute(.twoDigits).locale(language.locale))
        case .english:
            date.formatted(.dateTime.month(.abbreviated).day().year().hour().minute(.twoDigits).locale(language.locale))
        case .spanish:
            date.formatted(.dateTime.day().month(.abbreviated).year().hour(.twoDigits(amPM: .omitted)).minute(.twoDigits).locale(language.locale))
        case .french:
            date.formatted(.dateTime.day().month(.wide).year().hour(.twoDigits(amPM: .omitted)).minute(.twoDigits).locale(language.locale))
        }
    }

    static func timeText(_ date: Date, language: AppLanguage) -> String {
        date.formatted(
            .dateTime
                .hour()
                .minute(.twoDigits)
                .locale(language.locale)
        )
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
