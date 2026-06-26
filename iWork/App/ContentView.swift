import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WorkEntry.date, order: .reverse) private var entries: [WorkEntry]
    @Query private var settingsItems: [SettingsModel]

    @State private var selectedTab = AppTab.home
    @State private var selectedMonth = Date()
    @State private var showingEditor = false

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
                    .task { ensureSettingsExist() }
            }
        }
        .onAppear(perform: ensureSettingsExist)
    }

    private func ensureSettingsExist() {
        DatabaseManager.ensureSettingsExist(settings: settingsItems, in: modelContext)
    }
}

enum AppTab: Hashable {
    case home
    case statistics
    case settings
}

#Preview {
    ContentView()
        .modelContainer(for: SwiftDataContainer.schema, inMemory: true)
}
