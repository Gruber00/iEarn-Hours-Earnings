import SwiftUI

struct TrophyDetailSheet: View {
    let badge: AchievementBadge
    let totalEarnings: Double
    let currency: String
    let language: AppLanguage

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    Image(systemName: badge.symbolName)
                        .font(.system(size: 82, weight: .bold))
                        .foregroundStyle(badge.isUnlocked ? accentColor : .gray)
                        .symbolRenderingMode(.hierarchical)
                        .symbolEffect(.bounce, value: badge.isUnlocked)
                        .padding(.top, 24)

                    VStack(spacing: 8) {
                        Text(TrophiesViewModel.title(for: badge, language: language))
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)

                        Text(TrophiesViewModel.description(for: badge, language: language))
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 14) {
                        LabeledContent("trophies.requiredAmount".localized(language), value: badge.requiredAmount.formattedMoney(currency: currency, language: language))
                        LabeledContent("trophies.currentProgress".localized(language), value: TrophiesViewModel.progressText(for: badge, totalEarnings: totalEarnings, currency: currency, language: language))
                        LabeledContent("common.status".localized(language), value: TrophiesViewModel.statusText(for: badge, language: language))

                        if let unlockedText = TrophiesViewModel.unlockedDateText(for: badge, language: language) {
                            Text(unlockedText)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(accentColor)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ProgressView(value: TrophiesViewModel.progress(for: badge, totalEarnings: totalEarnings))
                                .tint(accentColor)
                        }
                    }
                    .padding(20)
                    .glassControl(cornerRadius: 28, tint: badge.isUnlocked ? accentColor.opacity(0.10) : .gray.opacity(0.06))
                }
                .padding(20)
            }
            .background(AppBackground())
            .navigationTitle("trophies.detailTitle".localized(language))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
