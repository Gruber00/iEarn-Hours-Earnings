//
//  ContentView.swift
//  iWork
//
//  Created by Felix on 26.06.26.
//

import Charts
import SwiftData
import SwiftUI

@Model
final class WorkEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var startTime: Date
    var endTime: Date
    var pauseMinutes: Int
    var note: String
    var workedHours: Double
    var earnedMoney: Double

    init(
        id: UUID = UUID(),
        date: Date,
        startTime: Date,
        endTime: Date,
        pauseMinutes: Int,
        note: String = "",
        hourlyRate: Double
    ) {
        let hours = WorkHoursViewModel.workedHours(startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes)

        self.id = id
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.pauseMinutes = pauseMinutes
        self.note = note
        self.workedHours = hours
        self.earnedMoney = hours * hourlyRate
    }

    func update(date: Date, startTime: Date, endTime: Date, pauseMinutes: Int, note: String, hourlyRate: Double) {
        self.date = date
        self.startTime = startTime
        self.endTime = endTime
        self.pauseMinutes = pauseMinutes
        self.note = note
        recalculate(hourlyRate: hourlyRate)
    }

    func recalculate(hourlyRate: Double) {
        workedHours = WorkHoursViewModel.workedHours(startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes)
        earnedMoney = workedHours * hourlyRate
    }
}

@Model
final class SettingsModel {
    var hourlyRate: Double
    var currency: String
    var defaultPause: Int

    init(hourlyRate: Double = 18.5, currency: String = "€", defaultPause: Int = 30) {
        self.hourlyRate = hourlyRate
        self.currency = currency
        self.defaultPause = defaultPause
    }
}

struct WorkHoursViewModel {
    static let currencies = ["€", "$", "£", "CHF", "¥"]
    static let pauseOptions = [0, 15, 30, 45, 60]

    static func workedHours(startTime: Date, endTime: Date, pauseMinutes: Int) -> Double {
        let seconds = endTime.timeIntervalSince(startTime) - Double(pauseMinutes * 60)
        return max(seconds / 3_600, 0)
    }

    static func monthEntries(from entries: [WorkEntry], selectedMonth: Date, calendar: Calendar = .current) -> [WorkEntry] {
        entries
            .filter { calendar.isDate($0.date, equalTo: selectedMonth, toGranularity: .month) }
            .sorted { $0.date > $1.date }
    }

    static func totalHours(_ entries: [WorkEntry]) -> Double {
        entries.reduce(0) { $0 + $1.workedHours }
    }

    static func totalEarnings(_ entries: [WorkEntry]) -> Double {
        entries.reduce(0) { $0 + $1.earnedMoney }
    }

    static func money(_ value: Double, currency: String) -> String {
        let formattedValue = value.formatted(.number.precision(.fractionLength(2)).locale(Locale(identifier: "de_DE")))
        return currency == "CHF" ? "CHF \(formattedValue)" : "\(formattedValue) \(currency)"
    }

    static func hoursAndMinutes(_ value: Double) -> String {
        let totalMinutes = Int((value * 60).rounded())
        return "\(totalMinutes / 60) h \(totalMinutes % 60) min"
    }

    static func decimalHours(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(1)).locale(Locale(identifier: "de_DE"))) + " h"
    }

    static func dayTitle(_ date: Date) -> String {
        date.formatted(.dateTime.day().month(.wide))
    }

    static func monthTitle(_ date: Date) -> String {
        date.formatted(.dateTime.month(.wide).year())
    }

    static func decimalInputText(_ value: Double) -> String {
        value.formatted(.number.precision(.fractionLength(2)).locale(Locale(identifier: "de_DE")))
    }
}

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
                        entries: WorkHoursViewModel.monthEntries(from: entries, selectedMonth: selectedMonth),
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
                    EntryEditorView(entry: nil, settings: settings)
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
        guard settingsItems.isEmpty else { return }
        modelContext.insert(SettingsModel())
    }
}

enum AppTab: Hashable {
    case home
    case statistics
    case settings
}

struct HomeView: View {
    let entries: [WorkEntry]
    let settings: SettingsModel
    @Binding var selectedMonth: Date
    @Binding var showingEditor: Bool

    @Environment(\.modelContext) private var modelContext
    @State private var editingEntry: WorkEntry?
    @State private var addButtonBounce = false

    private var totalHours: Double { WorkHoursViewModel.totalHours(entries) }
    private var totalEarnings: Double { WorkHoursViewModel.totalEarnings(entries) }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                AppBackground()

                ScrollView {
                    VStack(alignment: .leading, spacing: 22) {
                        MonthStepper(selectedMonth: $selectedMonth)

                        EarningsSummary(
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

                FloatingAddButton(isAnimating: addButtonBounce) {
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
                EntryEditorView(entry: entry, settings: settings)
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

struct EarningsSummary: View {
    let totalEarnings: Double
    let totalHours: Double
    let settings: SettingsModel

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            VStack(alignment: .leading, spacing: 6) {
                Label("Verdienst", systemImage: "banknote.fill")
                    .font(.title.bold())
                    .foregroundStyle(.primary)

                Text(WorkHoursViewModel.money(totalEarnings, currency: settings.currency))
                    .font(.system(size: 60, weight: .heavy, design: .rounded))
                    .foregroundStyle(.green)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .contentTransition(.numericText())
            }

            HStack(spacing: 12) {
                SummaryMetric(
                    title: "Arbeitsstunden diesen Monat",
                    value: WorkHoursViewModel.hoursAndMinutes(totalHours),
                    symbol: "clock.fill"
                )

                SummaryMetric(
                    title: "Stundenlohn",
                    value: WorkHoursViewModel.money(settings.hourlyRate, currency: settings.currency),
                    symbol: "dollarsign.circle.fill"
                )
            }
        }
        .padding(24)
        .surfaceCard(cornerRadius: 32)
        .animation(.smooth, value: totalEarnings)
        .animation(.smooth, value: totalHours)
    }
}

struct SummaryMetric: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .font(.title3)
                .foregroundStyle(.green)
                .symbolRenderingMode(.hierarchical)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)

            Text(value)
                .font(.headline.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .contentTransition(.numericText())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.quaternary.opacity(0.55), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}

struct FloatingAddButton: View {
    let isAnimating: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.green)
                .frame(width: 74, height: 74)
                .symbolEffect(.bounce, value: isAnimating)
                .scaleEffect(isAnimating ? 1.05 : 1)
        }
        .glassControl(cornerRadius: 37, tint: .green.opacity(0.12))
        .shadow(color: .green.opacity(0.32), radius: 20, x: 0, y: 12)
        .accessibilityLabel("Arbeitszeit hinzufügen")
    }
}

struct WorkEntryRow: View {
    let entry: WorkEntry
    let settings: SettingsModel

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "briefcase.fill")
                .font(.headline)
                .foregroundStyle(.green)
                .frame(width: 42, height: 42)
                .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(WorkHoursViewModel.dayTitle(entry.date))
                    .font(.headline)

                Text("\(entry.startTime.formatted(date: .omitted, time: .shortened)) - \(entry.endTime.formatted(date: .omitted, time: .shortened))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 10)

            VStack(alignment: .trailing, spacing: 5) {
                Text(WorkHoursViewModel.decimalHours(entry.workedHours))
                    .font(.headline)

                Text(WorkHoursViewModel.money(entry.earnedMoney, currency: settings.currency))
                    .font(.subheadline.bold())
                    .foregroundStyle(.green)
                    .contentTransition(.numericText())
            }
        }
        .padding(16)
        .surfaceCard(cornerRadius: 24)
    }
}

struct EmptyMonthView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "calendar.badge.plus")
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(.green)
                .symbolRenderingMode(.hierarchical)

            Text("Noch keine Arbeitszeiten")
                .font(.headline)

            Text("Füge einen Arbeitstag hinzu, um Verdienst und Statistik zu berechnen.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(28)
        .surfaceCard(cornerRadius: 28)
    }
}

struct EntryEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let entry: WorkEntry?
    let settings: SettingsModel

    @State private var date: Date
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var pauseMinutes: Int
    @State private var note: String

    private var calculatedHours: Double {
        WorkHoursViewModel.workedHours(startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes)
    }

    init(entry: WorkEntry?, settings: SettingsModel) {
        self.entry = entry
        self.settings = settings

        _date = State(initialValue: entry?.date ?? .now)
        _startTime = State(initialValue: entry?.startTime ?? Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: .now) ?? .now)
        _endTime = State(initialValue: entry?.endTime ?? Calendar.current.date(bySettingHour: 16, minute: 30, second: 0, of: .now) ?? .now)
        _pauseMinutes = State(initialValue: entry?.pauseMinutes ?? settings.defaultPause)
        _note = State(initialValue: entry?.note ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Arbeitszeit") {
                    DatePicker("Datum", selection: $date, displayedComponents: .date)
                    DatePicker("Beginn", selection: $startTime, displayedComponents: .hourAndMinute)
                    DatePicker("Ende", selection: $endTime, displayedComponents: .hourAndMinute)

                    Picker("Pause", selection: $pauseMinutes) {
                        ForEach(WorkHoursViewModel.pauseOptions, id: \.self) { minutes in
                            Text("\(minutes) Minuten").tag(minutes)
                        }
                    }
                }

                Section("Notiz") {
                    TextField("Optional", text: $note, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Berechnung") {
                    LabeledContent("Arbeitszeit", value: WorkHoursViewModel.hoursAndMinutes(calculatedHours))
                    LabeledContent("Verdienst", value: WorkHoursViewModel.money(calculatedHours * settings.hourlyRate, currency: settings.currency))
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .navigationTitle(entry == nil ? "Arbeitszeit hinzufügen" : "Arbeitszeit bearbeiten")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Abbrechen") { dismiss() }
                        .glassButtonIfAvailable()
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Speichern", action: save)
                        .fontWeight(.semibold)
                        .glassProminentIfAvailable()
                }
            }
        }
    }

    private func save() {
        withAnimation(.snappy) {
            if let entry {
                entry.update(date: date, startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes, note: note, hourlyRate: settings.hourlyRate)
            } else {
                let newEntry = WorkEntry(date: date, startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes, note: note, hourlyRate: settings.hourlyRate)
                modelContext.insert(newEntry)
            }
        }

        dismiss()
    }
}

struct StatisticsView: View {
    let entries: [WorkEntry]
    let settings: SettingsModel

    @State private var selectedMonth = Date()

    private var monthEntries: [WorkEntry] {
        WorkHoursViewModel.monthEntries(from: entries, selectedMonth: selectedMonth).sorted { $0.date < $1.date }
    }

    private var dailySummaries: [DailySummary] {
        DailySummary.make(from: monthEntries)
    }

    private var totalHours: Double { WorkHoursViewModel.totalHours(monthEntries) }
    private var totalEarnings: Double { WorkHoursViewModel.totalEarnings(monthEntries) }
    private var averageHours: Double { monthEntries.isEmpty ? 0 : totalHours / Double(monthEntries.count) }
    private var averageEarnings: Double { monthEntries.isEmpty ? 0 : totalEarnings / Double(monthEntries.count) }
    private var longestDay: Double { monthEntries.map(\.workedHours).max() ?? 0 }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    MonthStepper(selectedMonth: $selectedMonth)

                    ChartCard(title: "Arbeitsstunden pro Tag", symbol: "chart.xyaxis.line") {
                        DailyBarChart(data: dailySummaries, value: \.hours, color: .green, label: "Stunden")
                    }

                    ChartCard(title: "Verdienst pro Tag", symbol: "banknote.fill") {
                        DailyBarChart(data: dailySummaries, value: \.earnings, color: .blue, label: settings.currency)
                    }

                    VStack(spacing: 12) {
                        StatisticRow(title: "Gesamtstunden", value: WorkHoursViewModel.hoursAndMinutes(totalHours), symbol: "clock.fill")
                        StatisticRow(title: "Gesamtverdienst", value: WorkHoursViewModel.money(totalEarnings, currency: settings.currency), symbol: "banknote.fill")
                        StatisticRow(title: "Durchschnitt Stunden", value: WorkHoursViewModel.decimalHours(averageHours), symbol: "chart.line.uptrend.xyaxis")
                        StatisticRow(title: "Durchschnitt Verdienst", value: WorkHoursViewModel.money(averageEarnings, currency: settings.currency), symbol: "divide.circle.fill")
                        StatisticRow(title: "Anzahl Arbeitstage", value: "\(monthEntries.count)", symbol: "calendar")
                        StatisticRow(title: "Längster Arbeitstag", value: WorkHoursViewModel.decimalHours(longestDay), symbol: "timer")
                    }
                }
                .padding(20)
                .padding(.bottom, 24)
            }
            .background(AppBackground())
            .navigationTitle("Statistik")
        }
    }
}

struct DailySummary: Identifiable, Equatable {
    let id: Int
    let day: Int
    let hours: Double
    let earnings: Double

    static func make(from entries: [WorkEntry], calendar: Calendar = .current) -> [DailySummary] {
        let groupedEntries = Dictionary(grouping: entries) { calendar.component(.day, from: $0.date) }
        return (1...31).map { day in
            let entriesForDay = groupedEntries[day] ?? []
            return DailySummary(
                id: day,
                day: day,
                hours: WorkHoursViewModel.totalHours(entriesForDay),
                earnings: WorkHoursViewModel.totalEarnings(entriesForDay)
            )
        }
    }
}

struct ChartCard<Content: View>: View {
    let title: String
    let symbol: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: symbol)
                .font(.headline.bold())
                .symbolRenderingMode(.hierarchical)

            content
                .frame(height: 220)
        }
        .padding(18)
        .surfaceCard(cornerRadius: 28)
    }
}

struct DailyBarChart: View {
    let data: [DailySummary]
    let value: KeyPath<DailySummary, Double>
    let color: Color
    let label: String

    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Tag", item.day),
                y: .value(label, item[keyPath: value])
            )
            .foregroundStyle(color.gradient)
        }
        .chartXAxis {
            AxisMarks(values: [1, 5, 10, 15, 20, 25, 31])
        }
        .chartYAxis {
            AxisMarks(values: .automatic(desiredCount: 4))
        }
        .animation(.smooth, value: data)
    }
}

struct StatisticRow: View {
    let title: String
    let value: String
    let symbol: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol)
                .font(.subheadline.bold())
                .foregroundStyle(.green)
                .frame(width: 36, height: 36)
                .background(.green.opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer(minLength: 10)

            Text(value)
                .font(.headline.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
                .contentTransition(.numericText())
        }
        .padding(14)
        .surfaceCard(cornerRadius: 20)
    }
}

struct SettingsView: View {
    @Bindable var settings: SettingsModel
    let allEntries: [WorkEntry]

    @State private var hourlyRateText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Stundenlohn") {
                    HStack(spacing: 12) {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(.green)
                            .symbolRenderingMode(.hierarchical)

                        TextField("18,50", text: $hourlyRateText)
                            .keyboardType(.decimalPad)
                            .font(.title3.weight(.semibold))

                        Text(settings.currency)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Währung") {
                    Picker("Währung", selection: $settings.currency) {
                        ForEach(WorkHoursViewModel.currencies, id: \.self) { currency in
                            Text(currency).tag(currency)
                        }
                    }
                }

                Section("Standardpause") {
                    Picker("Pause", selection: $settings.defaultPause) {
                        ForEach(WorkHoursViewModel.pauseOptions, id: \.self) { minutes in
                            Text("\(minutes) Minuten").tag(minutes)
                        }
                    }
                }

                Section("App") {
                    LabeledContent("Version", value: appVersion)
                }
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .navigationTitle("Einstellungen")
            .onAppear {
                hourlyRateText = WorkHoursViewModel.decimalInputText(settings.hourlyRate)
            }
            .onChange(of: hourlyRateText) { _, newValue in
                updateHourlyRate(from: newValue)
            }
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private func updateHourlyRate(from text: String) {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        guard let hourlyRate = Double(normalized), hourlyRate >= 0, hourlyRate != settings.hourlyRate else { return }

        withAnimation(.smooth) {
            settings.hourlyRate = hourlyRate
            allEntries.forEach { $0.recalculate(hourlyRate: hourlyRate) }
        }
    }
}

struct MonthStepper: View {
    @Binding var selectedMonth: Date
    @State private var directionPulse = 0

    var body: some View {
        HStack(spacing: 14) {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.headline.bold())
                    .frame(width: 42, height: 42)
                    .symbolEffect(.bounce, value: directionPulse)
            }
            .glassButtonIfAvailable()
            .accessibilityLabel("Vorheriger Monat")

            Text(WorkHoursViewModel.monthTitle(selectedMonth))
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.headline.bold())
                    .frame(width: 42, height: 42)
                    .symbolEffect(.bounce, value: directionPulse)
            }
            .glassButtonIfAvailable()
            .accessibilityLabel("Nächster Monat")
        }
        .padding(8)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func previousMonth() {
        directionPulse += 1
        withAnimation(.smooth) {
            selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
        }
    }

    private func nextMonth() {
        directionPulse += 1
        withAnimation(.smooth) {
            selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
        }
    }
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color(.secondarySystemBackground),
                Color.green.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

private extension View {
    func surfaceCard(cornerRadius: CGFloat) -> some View {
        self
            .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(.primary.opacity(0.05), lineWidth: 1)
            }
            .shadow(color: .black.opacity(0.06), radius: 18, x: 0, y: 8)
    }

    @ViewBuilder
    func glassControl(cornerRadius: CGFloat, tint: Color = .clear) -> some View {
        if #available(iOS 26.0, *) {
            self
                .background(tint, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: cornerRadius))
        } else {
            self
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        }
    }

    @ViewBuilder
    func glassButtonIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glass)
        } else {
            self.buttonStyle(.bordered)
        }
    }

    @ViewBuilder
    func glassProminentIfAvailable() -> some View {
        if #available(iOS 26.0, *) {
            self.buttonStyle(.glassProminent)
        } else {
            self.buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [WorkEntry.self, SettingsModel.self], inMemory: true)
}
