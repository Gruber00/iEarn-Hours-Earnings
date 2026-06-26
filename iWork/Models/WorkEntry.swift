import Foundation
import SwiftData

@Model
final class WorkEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var startTime: Date
    var endTime: Date
    var pauseMinutes: Int
    var note: String
    var workedHours: Double
    var earnedMoney: Double

    init(
        id: UUID = UUID(),
        date: Date,
        startTime: Date,
        endTime: Date,
        pauseMinutes: Int,
        note: String = "",
        hourlyRate: Double
    ) {
        let hours = EarningsCalculator.workedHours(
            startTime: startTime,
            endTime: endTime,
            pauseMinutes: pauseMinutes
        )

        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.pauseMinutes = pauseMinutes
        self.note = note
        self.workedHours = hours
        self.earnedMoney = EarningsCalculator.earnings(workedHours: hours, hourlyRate: hourlyRate)
    }

    func update(date: Date, startTime: Date, endTime: Date, pauseMinutes: Int, note: String, hourlyRate: Double) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.pauseMinutes = pauseMinutes
        self.note = note
        recalculate(hourlyRate: hourlyRate)
    }

    func recalculate(hourlyRate: Double) {
        workedHours = EarningsCalculator.workedHours(startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes)
        earnedMoney = EarningsCalculator.earnings(workedHours: workedHours, hourlyRate: hourlyRate)
    }
}
