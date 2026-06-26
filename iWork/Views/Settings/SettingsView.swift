import SwiftData
import SwiftUI

struct SettingsView: View {
    @Bindable var settings: SettingsModel
    let allEntries: [WorkEntry]
    let language: AppLanguage

    @State private var hourlyRateText = ""
    @State private var monthlyGoalText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("settings.hourlyRate".localized(language)) {
                    HStack(spacing: 12) {
                        Image(systemName: "dollarsign.circle.fill")
                            .foregroundStyle(.green)
                            .symbolRenderingMode(.hierarchical)

                        TextField(settings.hourlyRate.appDecimalText(language: language), text: $hourlyRateText)
                            .keyboardType(.decimalPad)
                            .font(.title3.weight(.semibold))

                        Text(settings.currency)
                            .foregroundStyle(.secondary)
                    }
                }

                Section("goal.monthlyGoal".localized(language)) {
                    HStack(spacing: 12) {
                        Image(systemName: "target")
                            .foregroundStyle(.green)
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

                Section("settings.language".localized(language)) {
                    Picker("settings.language".localized(language), selection: $settings.selectedLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language.languageCode)
                        }
                    }
                }

                Section("settings.preferredHand".localized(language)) {
                    Picker("settings.preferredHand".localized(language), selection: $settings.preferredHand) {
                        ForEach(PreferredHand.allCases) { hand in
                            Text(hand.displayKey.localized(language)).tag(hand.rawValue)
                        }
                    }
                }

                Section("settings.currency".localized(language)) {
                    CurrencyPicker(currency: $settings.currency, language: language)
                }

                Section("settings.defaultPause".localized(language)) {
                    Picker("home.pause".localized(language), selection: $settings.defaultPause) {
                        ForEach(SettingsViewModel.pauseOptions, id: \.self) { minutes in
                            Text("\(minutes) \("common.minutes".localized(language))").tag(minutes)
                        }
                    }
                }

                Section("settings.app".localized(language)) {
                    LabeledContent("settings.appVersion".localized(language), value: appVersion)
                }
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
}
