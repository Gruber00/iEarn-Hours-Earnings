import Charts
import SwiftUI

struct GoalPieChartDetailSheet: View {
    let progress: GoalProgress
    let segments: [GoalChartSegment]
    let dailyShares: [DailyEarningsShare]
    let currency: String
    let language: AppLanguage

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack {
                        Chart(segments) { segment in
                            SectorMark(
                                angle: .value(segment.titleKey.localized(language), max(segment.amount, 0.0001)),
                                innerRadius: .ratio(0.66),
                                angularInset: 2.5
                            )
                            .foregroundStyle(segment.id == "earned" ? accentColor.gradient : Color.gray.opacity(0.35).gradient)
                        }
                        .chartLegend(.hidden)
                        .frame(height: 300)

                        VStack(spacing: 6) {
                            Image(systemName: progress.isGoalReached ? "target" : "chart.pie.fill")
                                .font(.title2.bold())
                                .foregroundStyle(accentColor)
                            Text(progress.percentText)
                                .font(.system(size: 42, weight: .heavy, design: .rounded))
                            Text(progress.isGoalReached ? "goal.goalReached".localized(language) : "goal.goalProgress".localized(language))
                                .font(.headline)
                                .foregroundStyle(progress.isGoalReached ? accentColor : .secondary)
                        }
                    }
                    .padding(18)
                    .glassControl(cornerRadius: 30, tint: accentColor.opacity(0.08))

                    VStack(spacing: 12) {
                        LabeledContent("goal.monthlyGoal".localized(language), value: progress.goalAmount.formattedMoney(currency: currency, language: language))
                        LabeledContent("goal.alreadyEarned".localized(language), value: progress.earnedAmount.formattedMoney(currency: currency, language: language))
                        LabeledContent("goal.remaining".localized(language), value: progress.remainingAmount.formattedMoney(currency: currency, language: language))
                        LabeledContent("goal.goalProgress".localized(language), value: progress.percentText)
                    }
                    .padding(18)
                    .surfaceCard(cornerRadius: 24)

                    VStack(alignment: .leading, spacing: 12) {
                        Label("goal.dailyEarningsShare".localized(language), systemImage: "target")
                            .font(.headline.bold())

                        if dailyShares.isEmpty {
                            Text("home.emptyTitle".localized(language))
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(14)
                        } else {
                            ForEach(dailyShares) { share in
                                DailyEarningsShareRow(share: share, currency: currency, language: language)
                            }
                        }
                    }
                    .padding(18)
                    .surfaceCard(cornerRadius: 24)
                }
                .padding(20)
            }
            .background(AppBackground())
            .navigationTitle("goal.goalDetails".localized(language))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
