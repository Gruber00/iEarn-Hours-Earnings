import SwiftUI

struct ThemeViewModel {
    static func selectedAccentColor(from storedValue: String) -> AppAccentColor {
        AppAccentColor(storedValue: storedValue)
    }

    static func accentColor(from storedValue: String) -> Color {
        ThemeService.accentColor(for: storedValue)
    }
}
