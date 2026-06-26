import Foundation

extension String {
    func localized(_ language: AppLanguage) -> String {
        LocalizationService.text(self, language: language)
    }
}
