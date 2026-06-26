import SwiftUI

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
                Text(entry.date.appDayTitle)
                    .font(.headline)

                Text("\(entry.startTime.formatted(date: .omitted, time: .shortened)) - \(entry.endTime.formatted(date: .omitted, time: .shortened))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 10)

            VStack(alignment: .trailing, spacing: 5) {
                Text(entry.workedHours.appDecimalHoursText)
                    .font(.headline)

                Text(entry.earnedMoney.formattedMoney(currency: settings.currency))
                    .font(.subheadline.bold())
                    .foregroundStyle(.green)
                    .contentTransition(.numericText())
            }
        }
        .padding(16)
        .surfaceCard(cornerRadius: 24)
    }
}
