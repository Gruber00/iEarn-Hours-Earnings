import SwiftUI

struct TrophyCard: View {
    let badge: AchievementBadge
    let totalEarnings: Double
    let currency: String
    let language: AppLanguage

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: badge.symbolName)
                .font(.system(size: 44, weight: .bold))
                .foregroundStyle(badge.isUnlocked ? accentColor : .gray)
                .symbolRenderingMode(.hierarchical)
                .symbolEffect(.bounce, value: badge.isUnlocked)

            VStack(alignment: .leading, spacing: 6) {
                Text(TrophiesViewModel.title(for: badge, language: language))
                    .font(.title3.bold())

                Text(TrophiesViewModel.description(for: badge, language: language))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            VStack(alignment: .leading, spacing: 8) {
                LabeledContent("trophies.requiredAmount".localized(language), value: badge.requiredAmount.formattedMoney(currency: currency, language: language))
                LabeledContent("common.status".localized(language), value: TrophiesViewModel.statusText(for: badge, language: language))

                if let unlockedText = TrophiesViewModel.unlockedDateText(for: badge, language: language) {
                    Text(unlockedText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    ProgressView(value: TrophiesViewModel.progress(for: badge, totalEarnings: totalEarnings))
                        .tint(accentColor)

                    Text(TrophiesViewModel.progressText(for: badge, totalEarnings: totalEarnings, currency: currency, language: language))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .trophyCardStyle(isUnlocked: badge.isUnlocked, accentColor: accentColor)
    }
}

private extension View {
    @ViewBuilder
    func trophyCardStyle(isUnlocked: Bool, accentColor: Color) -> some View {
        if isUnlocked {
            self
                .glassControl(cornerRadius: 28, tint: accentColor.opacity(0.10))
                .shadow(color: accentColor.opacity(0.25), radius: 18, x: 0, y: 10)
        } else {
            self
                .glassControl(cornerRadius: 28, tint: .gray.opacity(0.06))
                .opacity(0.82)
        }
    }
}
