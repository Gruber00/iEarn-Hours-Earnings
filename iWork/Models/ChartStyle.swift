import Foundation

/// Preferred visual style for statistics charts. Stored as a raw value in SwiftData settings.
enum ChartStyle: String, CaseIterable, Identifiable {
    case bar
    case line

    var id: String { rawValue }

    var displayKey: String {
        switch self {
        case .bar:
            "chart.bar"
        case .line:
            "chart.line"
        }
    }

    var descriptionKey: String {
        switch self {
        case .bar:
            "chart.barDescription"
        case .line:
            "chart.lineDescription"
        }
    }

    var symbolName: String {
        switch self {
        case .bar:
            "chart.bar.fill"
        case .line:
            "chart.xyaxis.line"
        }
    }

    init(storedValue: String) {
        self = ChartStyle(rawValue: storedValue) ?? .bar
    }
}
