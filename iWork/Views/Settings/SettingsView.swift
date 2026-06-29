import SwiftData
import SwiftUI

struct SettingsView: View {
    @Bindable var settings: SettingsModel
    let allEntries: [WorkEntry]
    let language: AppLanguage

    @Environment(\.modelContext) private var modelContext
    @Environment(\.appAccentColor) private var accentColor
    @State private var hourlyRateText = ""
    @State private var monthlyGoalText = ""
    @State private var roundingMessage: String?

    var body: some View {
        NavigationStack {
            Form {
                generalSection
                workTimeSection
                workTimeManagementSection
                onboardingSection
                informationSection
                CreditsFooter()
            }
            .scrollContentBackground(.hidden)
            .background(AppBackground())
            .navigationTitle("settings.title".localized(language))
            .onAppear {
                syncTextFields(language: language)
            }
            .onChange(of: hourlyRateText) { _, newValue in
                updateHourlyRate(from: newValue)
            }
            .onChange(of: monthlyGoalText) { _, newValue in
                updateMonthlyGoal(from: newValue)
            }
            .onChange(of: settings.selectedLanguage) { _, _ in
                syncTextFields(language: settings.appLanguage)
            }
            .onChange(of: settings.currency) { _, _ in
                syncTextFields(language: settings.appLanguage)
            }
            .overlay(alignment: .top) {
                if let roundingMessage {
                    Text(roundingMessage)
                        .font(.subheadline.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
        }
    }

    private var generalSection: some View {
        Section("settings.general".localized(language)) {
            Picker("settings.language".localized(language), selection: $settings.selectedLanguage) {
                ForEach(AppLanguage.allCases) { language in
                    Text(language.displayName).tag(language.languageCode)
                }
            }

            CurrencyPicker(currency: $settings.currency, language: language)

            AccentColorPicker(selectedAccentColor: $settings.accentColor, language: language)

            ChartStylePicker(chartStyle: $settings.chartStyle, language: language)

            Picker("settings.preferredHand".localized(language), selection: $settings.preferredHand) {
                ForEach(PreferredHand.allCases) { hand in
                    Text(hand.displayKey.localized(language)).tag(hand.rawValue)
                }
            }
        }
    }

    private var workTimeSection: some View {
        Section("settings.workTime".localized(language)) {
            hourlyRateRow

            Picker("settings.defaultPause".localized(language), selection: $settings.defaultPause) {
                ForEach(SettingsViewModel.pauseOptions, id: \.self) { minutes in
                    Text("\(minutes) \("common.minutes".localized(language))").tag(minutes)
                }
            }

            monthlyGoalRows
        }
    }

    private var workTimeManagementSection: some View {
        Section("settings.workTimeManagement".localized(language)) {
            RoundAllWorkEntriesButton(language: language) {
                roundAllWorkEntries()
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .listRowBackground(Color.clear)
        }
    }

    private var onboardingSection: some View {
        Section("onboarding.section".localized(language)) {
            RestartOnboardingButton(language: language) {
                OnboardingResetService.restartOnboarding(settings: settings, context: modelContext)
            }
            .listRowInsets(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
            .listRowBackground(Color.clear)
        }
    }

    private var informationSection: some View {
        Section("settings.information".localized(language)) {
            LabeledContent("settings.appVersion".localized(language), value: appVersion)
        }
    }

    private var hourlyRateRow: some View {
        HStack(spacing: 12) {
            Image(systemName: "dollarsign.circle.fill")
                .foregroundStyle(accentColor)
                .symbolRenderingMode(.hierarchical)

            TextField(settings.hourlyRate.appDecimalText(language: language), text: $hourlyRateText)
                .keyboardType(.decimalPad)
                .font(.title3.weight(.semibold))

            Text(settings.currency)
                .foregroundStyle(.secondary)
        }
    }

    private var monthlyGoalRows: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Image(systemName: "target")
                    .foregroundStyle(accentColor)
                    .symbolRenderingMode(.hierarchical)

                TextField(settings.monthlyGoalAmount.appDecimalText(language: language), text: $monthlyGoalText)
                    .keyboardType(.decimalPad)
                    .font(.title3.weight(.semibold))

                Text(settings.currency)
                    .foregroundStyle(.secondary)
            }

            LabeledContent(
                "goal.goalAmount".localized(language),
                value: settings.monthlyGoalAmount.formattedMoney(currency: settings.currency, language: language)
            )
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private func syncTextFields(language: AppLanguage) {
        hourlyRateText = settings.hourlyRate.appDecimalText(language: language)
        monthlyGoalText = settings.monthlyGoalAmount.appDecimalText(language: language)
    }

    private func updateHourlyRate(from text: String) {
        withAnimation(.smooth) {
            SettingsViewModel.updateHourlyRate(from: text, settings: settings, entries: allEntries)
        }
    }

    private func updateMonthlyGoal(from text: String) {
        withAnimation(.smooth) {
            SettingsViewModel.updateMonthlyGoal(from: text, settings: settings)
        }
    }

    private func roundAllWorkEntries() {
        do {
            let updatedCount = try WorkingTimeRoundingService.roundAllWorkEntries(
                allEntries,
                hourlyRate: settings.hourlyRate,
                context: modelContext
            )

            let message = updatedCount > 0
                ? String(format: "settings.roundAllEntriesSuccess".localized(language), updatedCount)
                : "settings.roundAllEntriesAlreadyRounded".localized(language)

            showRoundingMessage(message)
        } catch {
            showRoundingMessage("settings.roundAllEntriesAlreadyRounded".localized(language))
        }
    }

    private func showRoundingMessage(_ message: String) {
        withAnimation(.snappy) {
            roundingMessage = message
        }

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(2.2))
            withAnimation(.snappy) {
                roundingMessage = nil
            }
        }
    }
}
