import SwiftUI

struct TrophyCard: View {
    let badge: AchievementBadge
    let totalEarnings: Double
    let currency: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: badge.symbolName)
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(badge.isUnlocked ? .yellow : .gray)
                .symbolRenderingMode(.hierarchical)
                .symbolEffect(.bounce, value: badge.isUnlocked)

            VStack(alignment: .leading, spacing: 6) {
                Text(badge.title)
                    .font(.title3.bold())

                Text(badge.descriptionText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            VStack(alignment: .leading, spacing: 8) {
                LabeledContent("Benötigt", value: badge.requiredAmount.formattedMoney(currency: currency))
                LabeledContent("Status", value: TrophiesViewModel.statusText(for: badge))

                if let unlockedText = TrophiesViewModel.unlockedDateText(for: badge) {
                    Text(unlockedText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView(value: TrophiesViewModel.progress(for: badge, totalEarnings: totalEarnings))
                        .tint(.green)

                    Text(TrophiesViewModel.progressText(for: badge, totalEarnings: totalEarnings, currency: currency))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .trophyCardStyle(isUnlocked: badge.isUnlocked)
    }
}

private extension View {
    @ViewBuilder
    func trophyCardStyle(isUnlocked: Bool) -> some View {
        if isUnlocked {
            self
                .glassControl(cornerRadius: 28, tint: .yellow.opacity(0.10))
                .shadow(color: .yellow.opacity(0.25), radius: 18, x: 0, y: 10)
        } else {
            self
                .glassControl(cornerRadius: 28, tint: .gray.opacity(0.06))
                .opacity(0.82)
        }
    }
}
