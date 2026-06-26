import Foundation

extension Double {
    func appDecimalText(language: AppLanguage) -> String {
        formatted(.number.precision(.fractionLength(2)).locale(language.locale))
    }

    func appDecimalHoursText(language: AppLanguage) -> String {
        formatted(.number.precision(.fractionLength(1)).locale(language.locale)) + " " + "common.hourShort".localized(language)
    }

    func appHoursAndMinutesText(language: AppLanguage) -> String {
        let totalMinutes = Int((self * 60).rounded())
        return "\(totalMinutes / 60) \("common.hourShort".localized(language)) \(totalMinutes % 60) \("common.minuteShort".localized(language))"
    }

    func formattedMoney(currency: String, language: AppLanguage) -> String {
        let valueText = appDecimalText(language: language)
        return currency == "CHF" ? "CHF \(valueText)" : "\(valueText) \(currency)"
    }

    var appDecimalText: String { appDecimalText(language: .german) }
    var appDecimalHoursText: String { appDecimalHoursText(language: .german) }
    var appHoursAndMinutesText: String { appHoursAndMinutesText(language: .german) }

    func formattedMoney(currency: String) -> String {
        formattedMoney(currency: currency, language: .german)
    }
}
