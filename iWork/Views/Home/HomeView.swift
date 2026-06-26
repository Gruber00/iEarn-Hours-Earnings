import SwiftData
import SwiftUI

struct HomeView: View {
    let entries: [WorkEntry]
    let settings: SettingsModel
    @Binding var selectedMonth: Date
    @Binding var showingEditor: Bool

    @Environment(\.modelContext) private var modelContext
    @State private var editingEntry: WorkEntry?
    @State private var addButtonBounce = false

    private var totalHours: Double { HomeViewModel.totalHours(for: entries) }
    private var totalEarnings: Double { HomeViewModel.totalEarnings(for: entries) }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                AppBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        MonthStepper(selectedMonth: $selectedMonth)

                        EarningsCard(
                            totalEarnings: totalEarnings,
                            totalHours: totalHours,
                            settings: settings
                        )

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Arbeitstage")
                                .font(.title2.bold())

                            if entries.isEmpty {
                                EmptyMonthView()
                            } else {
                                LazyVStack(spacing: 12) {
                                    ForEach(entries) { entry in
                                        WorkEntryRow(entry: entry, settings: settings)
                                            .contentShape(.rect)
                                            .onTapGesture { editingEntry = entry }
                                            .swipeActions(edge: .trailing) {
                                                Button(role: .destructive) {
                                                    delete(entry)
                                                } label: {
                                                    Label("Löschen", systemImage: "trash.fill")
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

                GlassFloatingButton(isAnimating: addButtonBounce) {
                    addButtonBounce.toggle()
                    withAnimation(.bouncy(duration: 0.38, extraBounce: 0.18)) {
                        showingEditor = true
                    }
                }
                .padding(.trailing, 24)
                .padding(.bottom, 18)
            }
            .navigationTitle("Work Hours")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $editingEntry) { entry in
                AddWorkEntrySheet(entry: entry, settings: settings)
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
