import Foundation

struct DailyEarningsShare: Identifiable, Equatable {
    let id: Date
    let date: Date
    let earnedAmount: Double
    let percentageShare: Double
    let isTopDay: Bool
}
