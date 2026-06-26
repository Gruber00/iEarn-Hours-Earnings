import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case german = "de"
    case english = "en"
    case spanish = "es"
    case french = "fr"

    var id: String { languageCode }
    var languageCode: String { rawValue }

    var displayName: String {
        switch self {
        case .german: "Deutsch"
        case .english: "English"
        case .spanish: "Español"
        case .french: "Français"
        }
    }

    var localeIdentifier: String {
        switch self {
        case .german: "de_DE"
        case .english: "en_US"
        case .spanish: "es_ES"
        case .french: "fr_FR"
        }
    }

    var locale: Locale {
        Locale(identifier: localeIdentifier)
    }

    init(languageCode: String) {
        self = AppLanguage(rawValue: languageCode) ?? .german
    }
}
