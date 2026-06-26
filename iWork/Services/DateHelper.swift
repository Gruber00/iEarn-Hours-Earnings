import Foundation

struct DateHelper {
    static func monthTitle(_ date: Date, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = language.locale
        formatter.setLocalizedDateFormatFromTemplate("MMMM yyyy")
        return formatter.string(from: date)
    }

    static func dayTitle(_ date: Date, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = language.locale
        formatter.setLocalizedDateFormatFromTemplate("d MMMM")
        return formatter.string(from: date)
    }

    static func dateTimeText(_ date: Date, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = language.locale
        formatter.dateFormat = dateTimeFormat(for: language)
        return formatter.string(from: date)
    }

    static func timeText(_ date: Date, language: AppLanguage) -> String {
        let formatter = DateFormatter()
        formatter.locale = language.locale
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter.string(from: date)
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

    private static func dateTimeFormat(for language: AppLanguage) -> String {
        switch language {
        case .german:
            "dd.MM.yyyy, HH:mm"
        case .english:
            "MMM d, yyyy, h:mm a"
        case .spanish:
            "d MMM yyyy, HH:mm"
        case .french:
            "d MMMM yyyy, HH:mm"
        }
    }
}
