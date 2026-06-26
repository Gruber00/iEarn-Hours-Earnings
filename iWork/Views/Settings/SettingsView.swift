import SwiftData
import SwiftUI

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
                    CurrencyPicker(currency: $settings.currency)
                }

                Section("Standardpause") {
                    Picker("Pause", selection: $settings.defaultPause) {
                        ForEach(SettingsViewModel.pauseOptions, id: \.self) { minutes in
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
                hourlyRateText = settings.hourlyRate.appDecimalText
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
        withAnimation(.smooth) {
            SettingsViewModel.updateHourlyRate(from: text, settings: settings, entries: allEntries)
        }
    }
}
