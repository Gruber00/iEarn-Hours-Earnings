import SwiftUI

enum AppAccentColor: String, CaseIterable, Identifiable {
    case appleGreen
    case blue
    case purple
    case pink
    case orange
    case red
    case yellow
    case cyan
    case gray
    case black
    case brown
    case indigo
    case teal
    case mint

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .appleGreen: "Apple Green"
        case .blue: "Blue"
        case .purple: "Purple"
        case .pink: "Pink"
        case .orange: "Orange"
        case .red: "Red"
        case .yellow: "Yellow"
        case .cyan: "Cyan"
        case .gray: "Gray"
        case .black: "Black"
        case .brown: "Brown"
        case .indigo: "Indigo"
        case .teal: "Teal"
        case .mint: "Mint"
        }
    }

    var color: Color { swiftUIColor }

    var assetName: String { rawValue }

    var swiftUIColor: Color {
        switch self {
        case .appleGreen: .green
        case .blue: .blue
        case .purple: .purple
        case .pink: .pink
        case .orange: .orange
        case .red: .red
        case .yellow: .yellow
        case .cyan: .cyan
        case .gray: .gray
        case .black: .black
        case .brown: .brown
        case .indigo: .indigo
        case .teal: .teal
        case .mint: .mint
        }
    }

    init(storedValue: String) {
        self = AppAccentColor(rawValue: storedValue) ?? .appleGreen
    }
}
