import SwiftUI

struct GlassFloatingButton: View {
    let isAnimating: Bool
    let language: AppLanguage
    let action: () -> Void

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(accentColor)
                .frame(width: 74, height: 74)
                .symbolEffect(.bounce, value: isAnimating)
                .scaleEffect(isAnimating ? 1.05 : 1)
        }
        .glassControl(cornerRadius: 37, tint: accentColor.opacity(0.12))
        .shadow(color: accentColor.opacity(0.32), radius: 20, x: 0, y: 12)
        .accessibilityLabel("home.addWorkTime".localized(language))
        .animation(.smooth, value: accentColor)
    }
}
