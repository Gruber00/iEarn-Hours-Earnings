import Foundation

struct SampleData {
    static let settings = SettingsModel()

    static let entries: [WorkEntry] = [
        WorkEntry(
            date: .now,
            startTime: DateHelper.dateAt(hour: 8, minute: 0),
            endTime: DateHelper.dateAt(hour: 16, minute: 30),
            pauseMinutes: 30,
            hourlyRate: settings.hourlyRate
        )
    ]
}
