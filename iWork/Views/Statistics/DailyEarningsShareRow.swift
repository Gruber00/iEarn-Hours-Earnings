import SwiftUI

struct DailyEarningsShareRow: View {
    let share: DailyEarningsShare
    let currency: String
    let language: AppLanguage

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: share.isTopDay ? "target" : "calendar")
                .font(.subheadline.bold())
                .foregroundStyle(share.isTopDay ? .green : .secondary)
                .frame(width: 34, height: 34)
                .background((share.isTopDay ? Color.green : Color.gray).opacity(0.12), in: RoundedRectangle(cornerRadius: 12, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(share.date.appDayTitle(language: language))
                    .font(.headline)

                if share.isTopDay {
                    Text("goal.topEarningDay".localized(language))
                        .font(.caption)
                        .foregroundStyle(.green)
                }
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 4) {
                Text(share.earnedAmount.formattedMoney(currency: currency, language: language))
                    .font(.headline)

                Text(share.percentageShare.formatted(.percent.precision(.fractionLength(0)).locale(language.locale)))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(share.isTopDay ? Color.green.opacity(0.08) : Color.clear, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
