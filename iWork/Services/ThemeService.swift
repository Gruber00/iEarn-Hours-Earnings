import SwiftUI

struct ThemeService {
    static let defaultAccentColor = AppAccentColor.appleGreen

    static var currentAccentColor: Color {
        defaultAccentColor.swiftUIColor
    }

    static func currentAccentColor(for storedValue: String) -> Color {
        AppAccentColor(storedValue: storedValue).swiftUIColor
    }

    static func accentColor(for settings: SettingsModel) -> Color {
        currentAccentColor(for: settings.accentColor)
    }

    static func accentColor(for accentColor: AppAccentColor) -> Color {
        accentColor.swiftUIColor
    }

    static func accentColor(for storedValue: String) -> Color {
        currentAccentColor(for: storedValue)
    }

    static func confettiColors(primary: Color) -> [Color] {
        [primary, .yellow, .blue, .pink, .purple, .orange]
    }
}

private struct AppAccentColorEnvironmentKey: EnvironmentKey {
    static let defaultValue: Color = ThemeService.currentAccentColor
}

extension EnvironmentValues {
    var appAccentColor: Color {
        get { self[AppAccentColorEnvironmentKey.self] }
        set { self[AppAccentColorEnvironmentKey.self] = newValue }
    }
}
