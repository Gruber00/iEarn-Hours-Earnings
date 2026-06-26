import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkEntry.date, order: .reverse) private var entries: [WorkEntry]
    @Query private var settingsItems: [SettingsModel]
    @Query(sort: \AchievementBadge.requiredAmount) private var badges: [AchievementBadge]

    @State private var selectedTab = AppTab.home
    @State private var selectedMonth = Date()
    @State private var showingEditor = false

    private var achievementEvaluationSignature: String {
        let entrySignature = entries
            .map { "\($0.id.uuidString)-\($0.workedHours)-\($0.earnedMoney)" }
            .joined(separator: "|")
        let settingsSignature = settingsItems.first.map { "\($0.hourlyRate)-\($0.currency)-\($0.selectedLanguage)" } ?? "no-settings"
        let badgeSignature = badges
            .map { "\($0.requiredAmount)-\($0.isUnlocked)-\($0.unlockedAt?.timeIntervalSince1970 ?? 0)" }
            .joined(separator: "|")
        return entrySignature + settingsSignature + badgeSignature
    }

    var body: some View {
        Group {
            if let settings = settingsItems.first {
                let language = settings.appLanguage

                TabView(selection: $selectedTab) {
                    HomeView(
                        entries: HomeViewModel.monthEntries(from: entries, selectedMonth: selectedMonth),
                        settings: settings,
                        language: language,
                        selectedMonth: $selectedMonth,
                        showingEditor: $showingEditor
                    )
                    .tag(AppTab.home)
                    .tabItem { Label("tab.home".localized(language), systemImage: "house.fill") }

                    StatisticsView(entries: entries, settings: settings, language: language)
                        .tag(AppTab.statistics)
                        .tabItem { Label("tab.statistics".localized(language), systemImage: "chart.bar.fill") }

                    TrophiesView(badges: badges, entries: entries, settings: settings, language: language)
                        .tag(AppTab.trophies)
                        .tabItem { Label("tab.trophies".localized(language), systemImage: "trophy.fill") }

                    SettingsView(settings: settings, allEntries: entries, language: language)
                        .tag(AppTab.settings)
                        .tabItem { Label("tab.settings".localized(language), systemImage: "gearshape.fill") }
                }
                .tint(.green)
                .environment(\.locale, language.locale)
                .animation(.snappy, value: selectedTab)
                .animation(.snappy, value: settings.selectedLanguage)
                .sheet(isPresented: $showingEditor) {
                    AddWorkEntrySheet(entry: nil, settings: settings, language: language)
                        .environment(\.locale, language.locale)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                        .presentationBackground(.thinMaterial)
                }
            } else {
                ProgressView()
                    .task { preparePersistentData() }
            }
        }
        .onAppear(perform: preparePersistentData)
        .onChange(of: achievementEvaluationSignature) { _, _ in
            preparePersistentData()
        }
    }

    private func preparePersistentData() {
        DatabaseManager.ensureSettingsExist(settings: settingsItems, in: modelContext)
        DatabaseManager.ensureAchievementBadgesExist(badges: badges, in: modelContext)
        AchievementService.evaluateBadges(entries: entries, badges: badges)
    }
}

enum AppTab: Hashable {
    case home
    case statistics
    case trophies
    case settings
}

#Preview {
    ContentView()
        .modelContainer(for: SwiftDataContainer.schema, inMemory: true)
}
