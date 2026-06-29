import SwiftUI

struct WorkEntryRow: View {
    let entry: WorkEntry
    let settings: SettingsModel
    let language: AppLanguage

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: "briefcase.fill")
                .font(.headline)
                .foregroundStyle(accentColor)
                .frame(width: 42, height: 42)
                .background(accentColor.opacity(0.12), in: RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(entry.date.appDayTitle(language: language))
                    .font(.headline)

                Text("\(entry.startTime.appTimeText(language: language)) - \(entry.endTime.appTimeText(language: language))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 10)

            VStack(alignment: .trailing, spacing: 5) {
                Text(entry.workedHours.appDecimalHoursText(language: language))
                    .font(.headline)

                Text(entry.earnedMoney.formattedMoney(currency: settings.currency, language: language))
                    .font(.subheadline.bold())
                    .foregroundStyle(accentColor)
                    .contentTransition(.numericText())
            }
        }
        .padding(16)
        .surfaceCard(cornerRadius: 24)
        .animation(.smooth, value: accentColor)
    }
}
