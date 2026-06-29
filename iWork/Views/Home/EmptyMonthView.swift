import SwiftUI

struct EmptyMonthView: View {
    let language: AppLanguage

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(accentColor)
                .symbolRenderingMode(.hierarchical)

            Text("home.emptyTitle".localized(language))
                .font(.headline)

            Text("home.emptyMessage".localized(language))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .surfaceCard(cornerRadius: 28)
        .animation(.smooth, value: accentColor)
    }
}
