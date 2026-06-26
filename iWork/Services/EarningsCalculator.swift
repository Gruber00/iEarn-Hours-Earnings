import Foundation

struct EarningsCalculator {
    static func workedHours(startTime: Date, endTime: Date, pauseMinutes: Int) -> Double {
        let seconds = endTime.timeIntervalSince(startTime) - Double(pauseMinutes * 60)
        return max(seconds / 3_600, 0)
    }

    static func earnings(workedHours: Double, hourlyRate: Double) -> Double {
        workedHours * hourlyRate
    }
}
