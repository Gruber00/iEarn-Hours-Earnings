import SwiftData
import SwiftUI

struct AddWorkEntrySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    let entry: WorkEntry?
    let settings: SettingsModel
    let language: AppLanguage

    @State private var date: Date
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var pauseMinutes: Int
    @State private var note: String
    @State private var celebrationService = CelebrationService()
    @State private var isSaving = false

    private var calculatedHours: Double {
        EarningsCalculator.workedHours(startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes)
    }

    private var canSave: Bool {
        calculatedHours > 0 && !isSaving
    }

    init(entry: WorkEntry?, settings: SettingsModel, language: AppLanguage) {
        self.entry = entry
        self.settings = settings
        self.language = language

        _date = State(initialValue: entry?.date ?? .now)
        _startTime = State(initialValue: entry?.startTime ?? DateHelper.dateAt(hour: 8, minute: 0))
        _endTime = State(initialValue: entry?.endTime ?? DateHelper.dateAt(hour: 16, minute: 30))
        _pauseMinutes = State(initialValue: entry?.pauseMinutes ?? settings.defaultPause)
        _note = State(initialValue: entry?.note ?? "")
    }

    var body: some View {
        ZStack {
            NavigationStack {
                Form {
                    Section("home.workTime".localized(language)) {
                        DatePicker("home.date".localized(language), selection: $date, displayedComponents: .date)
                        DatePicker("home.start".localized(language), selection: $startTime, displayedComponents: .hourAndMinute)
                        DatePicker("home.end".localized(language), selection: $endTime, displayedComponents: .hourAndMinute)

                        Picker("home.pause".localized(language), selection: $pauseMinutes) {
                            ForEach(SettingsViewModel.pauseOptions, id: \.self) { minutes in
                                Text("\(minutes) \("common.minutes".localized(language))").tag(minutes)
                            }
                        }
                    }

                    Section("home.note".localized(language)) {
                        TextField("common.optional".localized(language), text: $note, axis: .vertical)
                            .lineLimit(2...4)
                    }

                    Section("home.calculation".localized(language)) {
                        LabeledContent("home.workTime".localized(language), value: calculatedHours.appHoursAndMinutesText(language: language))
                        LabeledContent("home.earnings".localized(language), value: EarningsCalculator.earnings(workedHours: calculatedHours, hourlyRate: settings.hourlyRate).formattedMoney(currency: settings.currency, language: language))
                    }
                }
                .scrollContentBackground(.hidden)
                .background(AppBackground())
                .navigationTitle(entry == nil ? "home.addWorkTime".localized(language) : "home.editWorkTime".localized(language))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("common.cancel".localized(language)) { dismiss() }
                            .glassButtonIfAvailable()
                            .disabled(isSaving)
                    }

                    ToolbarItem(placement: .confirmationAction) {
                        Button("common.save".localized(language), action: save)
                            .fontWeight(.semibold)
                            .glassProminentIfAvailable()
                            .disabled(!canSave)
                    }
                }
            }

            SuccessOverlay(
                isVisible: celebrationService.isSuccessVisible,
                message: "home.workEntrySaved".localized(language),
                trigger: celebrationService.hapticTrigger
            )

            ConfettiOverlay(
                isActive: celebrationService.isConfettiVisible,
                trigger: celebrationService.confettiTrigger
            )
        }
        .sensoryFeedback(.success, trigger: celebrationService.hapticTrigger)
    }

    private func save() {
        guard canSave else { return }
        isSaving = true

        if let entry {
            withAnimation(.snappy) {
                entry.update(date: date, startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes, note: note, hourlyRate: settings.hourlyRate)
            }

            do {
                try modelContext.save()
                dismiss()
            } catch {
                isSaving = false
            }
        } else {
            let newEntry = WorkEntry(date: date, startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes, note: note, hourlyRate: settings.hourlyRate)

            do {
                modelContext.insert(newEntry)
                try modelContext.save()

                Task { @MainActor in
                    await celebrationService.playSuccessfulSaveSequence(dismiss: dismiss)
                    isSaving = false
                }
            } catch {
                modelContext.delete(newEntry)
                isSaving = false
            }
        }
    }
}
