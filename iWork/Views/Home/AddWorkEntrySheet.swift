import SwiftData
import SwiftUI

struct AddWorkEntrySheet: View {
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
        EarningsCalculator.workedHours(startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes)
    }

    init(entry: WorkEntry?, settings: SettingsModel) {
        self.entry = entry
        self.settings = settings

        _date = State(initialValue: entry?.date ?? .now)
        _startTime = State(initialValue: entry?.startTime ?? DateHelper.dateAt(hour: 8, minute: 0))
        _endTime = State(initialValue: entry?.endTime ?? DateHelper.dateAt(hour: 16, minute: 30))
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
                        ForEach(SettingsViewModel.pauseOptions, id: \.self) { minutes in
                            Text("\(minutes) Minuten").tag(minutes)
                        }
                    }
                }

                Section("Notiz") {
                    TextField("Optional", text: $note, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Berechnung") {
                    LabeledContent("Arbeitszeit", value: calculatedHours.appHoursAndMinutesText)
                    LabeledContent("Verdienst", value: EarningsCalculator.earnings(workedHours: calculatedHours, hourlyRate: settings.hourlyRate).formattedMoney(currency: settings.currency))
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
