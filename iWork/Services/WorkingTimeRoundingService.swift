import Foundation
import SwiftData

struct WorkingTimeRoundingService {
    static func roundToNextHalfHour(_ hours: Double) -> Double {
        guard hours.isFinite, hours > 0 else { return 0 }

        let totalMinutes = Int(ceil(hours * 60))
        let remainder = totalMinutes % 30
        let roundedMinutes = remainder == 0 ? totalMinutes : totalMinutes + (30 - remainder)
        return Double(roundedMinutes) / 60
    }

    static func calculateRoundedHours(startTime: Date, endTime: Date, pauseMinutes: Int, shouldRound: Bool) -> Double {
        let exactHours = EarningsCalculator.workedHours(
            startTime: startTime,
            endTime: endTime,
            pauseMinutes: pauseMinutes
        )

        return shouldRound ? roundToNextHalfHour(exactHours) : exactHours
    }

    @MainActor
    static func roundAllWorkEntries(_ entries: [WorkEntry], hourlyRate: Double, context: ModelContext) throws -> Int {
        var updatedCount = 0

        for entry in entries where entry.roundWorkingTime == false {
            entry.roundWorkingTime = true
            entry.recalculate(hourlyRate: hourlyRate)
            updatedCount += 1
        }

        if updatedCount > 0 {
            try context.save()
        }

        return updatedCount
    }
}
