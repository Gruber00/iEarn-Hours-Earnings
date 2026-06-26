import SwiftUI

struct EmptyMonthView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(.green)
                .symbolRenderingMode(.hierarchical)

            Text("Noch keine Arbeitszeiten")
                .font(.headline)

            Text("Füge einen Arbeitstag hinzu, um Verdienst und Statistik zu berechnen.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .surfaceCard(cornerRadius: 28)
    }
}
