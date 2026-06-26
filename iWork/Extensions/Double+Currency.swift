import Foundation

extension Double {
    var appDecimalText: String {
        formatted(.number.precision(.fractionLength(2)).locale(Locale(identifier: "de_DE")))
    }

    var appDecimalHoursText: String {
        formatted(.number.precision(.fractionLength(1)).locale(Locale(identifier: "de_DE"))) + " h"
    }

    var appHoursAndMinutesText: String {
        let totalMinutes = Int((self * 60).rounded())
        return "\(totalMinutes / 60) h \(totalMinutes % 60) min"
    }

    func formattedMoney(currency: String) -> String {
        currency == "CHF" ? "CHF \(appDecimalText)" : "\(appDecimalText) \(currency)"
    }
}
