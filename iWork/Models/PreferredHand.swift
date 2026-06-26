import SwiftUI

enum PreferredHand: String, CaseIterable, Identifiable {
    case left
    case right

    var id: String { rawValue }

    var displayKey: String {
        switch self {
        case .left: "settings.preferredHand.left"
        case .right: "settings.preferredHand.right"
        }
    }

    var alignment: Alignment {
        switch self {
        case .left: .bottomLeading
        case .right: .bottomTrailing
        }
    }

    var horizontalPaddingEdge: Edge.Set {
        switch self {
        case .left: .leading
        case .right: .trailing
        }
    }

    init(storedValue: String) {
        self = PreferredHand(rawValue: storedValue) ?? .left
    }
}
