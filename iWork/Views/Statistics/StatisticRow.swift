import SwiftUI

struct StatisticRow: View {
    let title: String
    let value: String
    let symbol: String

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.subheadline.bold())
                .foregroundStyle(accentColor)
                .frame(width: 36, height: 36)
                .background(accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer(minLength: 10)

            Text(value)
                .font(.headline.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .contentTransition(.numericText())
        }
        .padding(14)
        .surfaceCard(cornerRadius: 20)
        .animation(.smooth, value: accentColor)
    }
}
