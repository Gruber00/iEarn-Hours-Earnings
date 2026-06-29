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
    var roundWorkingTime: Bool = false
    var workedHours: Double
    var earnedMoney: Double

    init(
        id: UUID = UUID(),
        date: Date,
        startTime: Date,
        endTime: Date,
        pauseMinutes: Int,
        note: String = "",
        roundWorkingTime: Bool = false,
        hourlyRate: Double
    ) {
        let hours = WorkingTimeRoundingService.calculateRoundedHours(
            startTime: startTime,
            endTime: endTime,
            pauseMinutes: pauseMinutes,
            shouldRound: roundWorkingTime
        )

        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.pauseMinutes = pauseMinutes
        self.note = note
        self.roundWorkingTime = roundWorkingTime
        self.workedHours = hours
        self.earnedMoney = EarningsCalculator.earnings(workedHours: hours, hourlyRate: hourlyRate)
    }

    func update(
        date: Date,
        startTime: Date,
        endTime: Date,
        pauseMinutes: Int,
        note: String,
        roundWorkingTime: Bool,
        hourlyRate: Double
    ) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.pauseMinutes = pauseMinutes
        self.note = note
        self.roundWorkingTime = roundWorkingTime
        recalculate(hourlyRate: hourlyRate)
    }

    func recalculate(hourlyRate: Double) {
        workedHours = WorkingTimeRoundingService.calculateRoundedHours(
            startTime: startTime,
            endTime: endTime,
            pauseMinutes: pauseMinutes,
            shouldRound: roundWorkingTime
        )
        earnedMoney = EarningsCalculator.earnings(workedHours: workedHours, hourlyRate: hourlyRate)
    }
}
