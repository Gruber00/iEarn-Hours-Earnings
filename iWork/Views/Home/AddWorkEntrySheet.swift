import SwiftData
import SwiftUI

struct AddWorkEntrySheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.appAccentColor) private var accentColor

    let entry: WorkEntry?
    let settings: SettingsModel
    let language: AppLanguage

    @State private var date: Date
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var pauseMinutes: Int
    @State private var roundWorkingTime: Bool
    @State private var note: String
    @State private var celebrationService = CelebrationService()
    @State private var isSaving = false
    @State private var showingLiveActivityMessage = false
    @State private var showingDeleteConfirmation = false
    @State private var showingDeleteMessage = false
    @State private var deleteHapticTrigger = 0

    private var exactHours: Double {
        EarningsCalculator.workedHours(startTime: startTime, endTime: endTime, pauseMinutes: pauseMinutes)
    }

    private var calculatedHours: Double {
        WorkingTimeRoundingService.calculateRoundedHours(
            startTime: startTime,
            endTime: endTime,
            pauseMinutes: pauseMinutes,
            shouldRound: roundWorkingTime
        )
    }

    private var calculatedEarnings: Double {
        EarningsCalculator.earnings(workedHours: calculatedHours, hourlyRate: settings.hourlyRate)
    }

    private var canSave: Bool {
        exactHours > 0 && !isSaving
    }

    init(entry: WorkEntry?, settings: SettingsModel, language: AppLanguage) {
        self.entry = entry
        self.settings = settings
        self.language = language

        _date = State(initialValue: entry?.date ?? .now)
        _startTime = State(initialValue: entry?.startTime ?? DateHelper.dateAt(hour: 8, minute: 0))
        _endTime = State(initialValue: entry?.endTime ?? DateHelper.dateAt(hour: 16, minute: 30))
        _pauseMinutes = State(initialValue: entry?.pauseMinutes ?? settings.defaultPause)
        _roundWorkingTime = State(initialValue: entry?.roundWorkingTime ?? false)
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

                        Toggle(isOn: $roundWorkingTime.animation(.snappy)) {
                            Label("home.roundWorkingTime".localized(language), systemImage: "clock.badge.checkmark")
                                .symbolRenderingMode(.hierarchical)
                        }
                        .tint(accentColor)
                    }

                    Section("home.note".localized(language)) {
                        TextField("common.optional".localized(language), text: $note, axis: .vertical)
                            .lineLimit(2...4)
                    }

                    Section("home.calculation".localized(language)) {
                        LabeledContent("home.workTime".localized(language), value: exactHours.appHoursAndMinutesText(language: language))

                        if roundWorkingTime {
                            LabeledContent("home.roundedWorkingTime".localized(language), value: calculatedHours.appHoursAndMinutesText(language: language))
                                .foregroundStyle(accentColor)
                                .contentTransition(.numericText())
                        }

                        LabeledContent("home.earnings".localized(language), value: calculatedEarnings.formattedMoney(currency: settings.currency, language: language))
                            .contentTransition(.numericText())
                    }
                }
                .scrollContentBackground(.hidden)
                .background(AppBackground())
                .navigationTitle(entry == nil ? "home.addWorkTime".localized(language) : "home.editWorkTime".localized(language))
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        if entry == nil {
                            SheetToolbarButton(
                                title: "home.startTracking".localized(language),
                                systemImage: "play.circle.fill",
                                action: startTracking
                            )
                            .disabled(isSaving)
                        } else {
                            Button {
                                showingDeleteConfirmation = true
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(.red)
                                    .symbolRenderingMode(.hierarchical)
                            }
                                .glassButtonIfAvailable()
                                .sensoryFeedback(.warning, trigger: deleteHapticTrigger)
                                .disabled(isSaving)
                                .accessibilityLabel("home.deleteWorkEntry".localized(language))
                        }
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
        .confirmationDialog(
            "home.deleteWorkEntry".localized(language),
            isPresented: $showingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("home.deleteConfirmAction".localized(language), role: .destructive) {
                deleteEntry()
            }

            Button("common.cancel".localized(language), role: .cancel) {}
        } message: {
            Text("home.deleteWorkEntryMessage".localized(language))
        }
        .overlay(alignment: .top) {
            if showingLiveActivityMessage || showingDeleteMessage {
                Text(showingDeleteMessage ? "home.workEntryDeleted".localized(language) : "home.liveActivityPreparing".localized(language))
                    .font(.subheadline.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(.ultraThinMaterial, in: Capsule())
                    .padding(.top, 18)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.smooth, value: accentColor)
    }

    private func startTracking() {
        LiveActivityService.startWorkTracking()
        withAnimation(.snappy) {
            showingLiveActivityMessage = true
        }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.8))
            withAnimation(.snappy) {
                showingLiveActivityMessage = false
            }
        }
    }

    private func save() {
        guard canSave else { return }
        isSaving = true

        if let entry {
            withAnimation(.snappy) {
                entry.update(
                    date: date,
                    startTime: startTime,
                    endTime: endTime,
                    pauseMinutes: pauseMinutes,
                    note: note,
                    roundWorkingTime: roundWorkingTime,
                    hourlyRate: settings.hourlyRate
                )
            }

            do {
                try modelContext.save()
                dismiss()
            } catch {
                isSaving = false
            }
        } else {
            let newEntry = WorkEntry(
                date: date,
                startTime: startTime,
                endTime: endTime,
                pauseMinutes: pauseMinutes,
                note: note,
                roundWorkingTime: roundWorkingTime,
                hourlyRate: settings.hourlyRate
            )

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

    private func deleteEntry() {
        guard let entry else { return }
        deleteHapticTrigger += 1

        withAnimation(.snappy) {
            modelContext.delete(entry)
            showingDeleteMessage = true
        }

        do {
            try modelContext.save()

            Task { @MainActor in
                try? await Task.sleep(for: .seconds(0.45))
                dismiss()
            }
        } catch {
            showingDeleteMessage = false
        }
    }
}
