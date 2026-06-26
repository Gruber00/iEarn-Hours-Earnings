import SwiftUI

struct TrophiesView: View {
    let badges: [AchievementBadge]
    let entries: [WorkEntry]
    let settings: SettingsModel
    let language: AppLanguage

    @State private var selectedBadge: AchievementBadge?

    private var sortedBadges: [AchievementBadge] {
        TrophiesViewModel.sortedBadges(badges)
    }

    private var totalEarnings: Double {
        TrophiesViewModel.totalEarnings(from: entries)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("trophies.title".localized(language))
                            .font(.largeTitle.bold())

                        Text("trophies.subtitle".localized(language))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 2)

                    ForEach(sortedBadges) { badge in
                        TrophyCard(
                            badge: badge,
                            totalEarnings: totalEarnings,
                            currency: settings.currency,
                            language: language
                        )
                        .contentShape(.rect)
                        .onTapGesture { selectedBadge = badge }
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(AppBackground())
            .navigationTitle("trophies.title".localized(language))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedBadge) { badge in
                TrophyDetailSheet(
                    badge: badge,
                    totalEarnings: totalEarnings,
                    currency: settings.currency,
                    language: language
                )
                .environment(\.locale, language.locale)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
                .presentationBackground(.thinMaterial)
            }
        }
    }
}
