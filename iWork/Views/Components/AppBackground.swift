import SwiftUI

struct AppBackground: View {
    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color(.secondarySystemBackground),
                accentColor.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        .animation(.smooth, value: accentColor)
    }
}
