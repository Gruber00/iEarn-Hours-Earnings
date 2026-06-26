import Foundation

extension Date {
    func appDayTitle(language: AppLanguage) -> String {
        DateHelper.dayTitle(self, language: language)
    }

    func appMonthTitle(language: AppLanguage) -> String {
        DateHelper.monthTitle(self, language: language)
    }

    func appTimeText(language: AppLanguage) -> String {
        DateHelper.timeText(self, language: language)
    }

    func appDateTimeText(language: AppLanguage) -> String {
        DateHelper.dateTimeText(self, language: language)
    }
}
