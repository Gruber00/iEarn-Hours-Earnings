import Foundation

extension Date {
    var appDayTitle: String {
        DateHelper.dayTitle(self)
    }

    var appMonthTitle: String {
        DateHelper.monthTitle(self)
    }
}
