import SwiftData
import SwiftUI

struct HomeView: View {
    let entries: [WorkEntry]
    let settings: SettingsModel
    let language: AppLanguage
    @Binding var selectedMonth: Date
    @Binding var showingEditor: Bool

    @Environment(\.modelContext) private var modelContext
    @State private var editingEntry: WorkEntry?
    @State private var addButtonBounce = false

    private var totalHours: Double { HomeViewModel.totalHours(for: entries) }
    private var totalEarnings: Double { HomeViewModel.totalEarnings(for: entries) }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomLeading) {
                AppBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        MonthStepper(selectedMonth: $selectedMonth, language: language)

                        EarningsCard(
                            totalEarnings: totalEarnings,
                            totalHours: totalHours,
                            settings: settings,
                            language: language
                        )

                        VStack(alignment: .leading, spacing: 12) {
                            Text("home.workDays".localized(language))
                                .font(.title2.bold())

                            if entries.isEmpty {
                                EmptyMonthView(language: language)
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(entries) { entry in
                                        WorkEntryRow(entry: entry, settings: settings, language: language)
                                            .contentShape(.rect)
                                            .onTapGesture { editingEntry = entry }
                                            .swipeActions(edge: .trailing) {
                                                Button(role: .destructive) {
                                                    delete(entry)
                                                } label: {
                                                    Label("common.delete".localized(language), systemImage: "trash.fill")
                                                }
                                            }
                                    }
                                }
                                .animation(.snappy, value: entries.map(\.id))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 104)
                }

                GlassFloatingButton(isAnimating: addButtonBounce, language: language) {
                    addButtonBounce.toggle()
                    withAnimation(.bouncy(duration: 0.38, extraBounce: 0.18)) {
                        showingEditor = true
                    }
                }
                .padding(.leading, 24)
                .padding(.bottom, 18)
            }
            .navigationTitle("app.title".localized(language))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $editingEntry) { entry in
                AddWorkEntrySheet(entry: entry, settings: settings, language: language)
                    .environment(\.locale, language.locale)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
                    .presentationBackground(.thinMaterial)
            }
        }
    }

    private func delete(_ entry: WorkEntry) {
        withAnimation(.snappy) {
            modelContext.delete(entry)
        }
    }
}
