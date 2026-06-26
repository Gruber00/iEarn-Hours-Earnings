import SwiftData
import SwiftUI

struct SettingsView: View {
    @Bindable var settings: SettingsModel
    let allEntries: [WorkEntry]
    let language: AppLanguage

    @State private var hourlyRateText = ""

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

                Section("settings.language".localized(language)) {
                    Picker("settings.language".localized(language), selection: $settings.selectedLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language.languageCode)
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
                hourlyRateText = settings.hourlyRate.appDecimalText(language: language)
            }
            .onChange(of: hourlyRateText) { _, newValue in
                updateHourlyRate(from: newValue)
            }
            .onChange(of: settings.selectedLanguage) { _, _ in
                hourlyRateText = settings.hourlyRate.appDecimalText(language: settings.appLanguage)
            }
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }

    private func updateHourlyRate(from text: String) {
        withAnimation(.smooth) {
            SettingsViewModel.updateHourlyRate(from: text, settings: settings, entries: allEntries)
        }
    }
}
