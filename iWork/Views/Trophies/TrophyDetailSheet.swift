import SwiftUI

struct TrophyDetailSheet: View {
    let badge: AchievementBadge
    let totalEarnings: Double
    let currency: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    Image(systemName: badge.symbolName)
                        .font(.system(size: 82, weight: .bold))
                        .foregroundStyle(badge.isUnlocked ? .yellow : .gray)
                        .symbolRenderingMode(.hierarchical)
                        .symbolEffect(.bounce, value: badge.isUnlocked)
                        .padding(.top, 24)

                    VStack(spacing: 8) {
                        Text(badge.title)
                            .font(.largeTitle.bold())
                            .multilineTextAlignment(.center)

                        Text(badge.descriptionText)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    VStack(spacing: 14) {
                        LabeledContent("Benötigter Betrag", value: badge.requiredAmount.formattedMoney(currency: currency))
                        LabeledContent("Aktueller Fortschritt", value: TrophiesViewModel.progressText(for: badge, totalEarnings: totalEarnings, currency: currency))
                        LabeledContent("Status", value: TrophiesViewModel.statusText(for: badge))

                        if let unlockedText = TrophiesViewModel.unlockedDateText(for: badge) {
                            Text(unlockedText)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.green)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        } else {
                            ProgressView(value: TrophiesViewModel.progress(for: badge, totalEarnings: totalEarnings))
                                .tint(.green)
                        }
                    }
                    .padding(20)
                    .glassControl(cornerRadius: 28, tint: badge.isUnlocked ? .yellow.opacity(0.10) : .gray.opacity(0.06))
                }
                .padding(20)
            }
            .background(AppBackground())
            .navigationTitle("Trophäe")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
