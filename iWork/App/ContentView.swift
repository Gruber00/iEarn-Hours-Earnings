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
        let settingsSignature = settingsItems.first.map { "\($0.hourlyRate)-\($0.currency)" } ?? "no-settings"
        let badgeSignature = badges
            .map { "\($0.requiredAmount)-\($0.isUnlocked)-\($0.unlockedAt?.timeIntervalSince1970 ?? 0)" }
            .joined(separator: "|")
        return entrySignature + settingsSignature + badgeSignature
    }

    var body: some View {
        Group {
            if let settings = settingsItems.first {
                TabView(selection: $selectedTab) {
                    HomeView(
                        entries: HomeViewModel.monthEntries(from: entries, selectedMonth: selectedMonth),
                        settings: settings,
                        selectedMonth: $selectedMonth,
                        showingEditor: $showingEditor
                    )
                    .tag(AppTab.home)
                    .tabItem { Label("Home", systemImage: "house.fill") }

                    StatisticsView(entries: entries, settings: settings)
                        .tag(AppTab.statistics)
                        .tabItem { Label("Statistik", systemImage: "chart.bar.fill") }

                    TrophiesView(badges: badges, entries: entries, settings: settings)
                        .tag(AppTab.trophies)
                        .tabItem { Label("Trophäen", systemImage: "trophy.fill") }

                    SettingsView(settings: settings, allEntries: entries)
                        .tag(AppTab.settings)
                        .tabItem { Label("Einstellungen", systemImage: "gearshape.fill") }
                }
                .tint(.green)
                .animation(.snappy, value: selectedTab)
                .sheet(isPresented: $showingEditor) {
                    AddWorkEntrySheet(entry: nil, settings: settings)
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
