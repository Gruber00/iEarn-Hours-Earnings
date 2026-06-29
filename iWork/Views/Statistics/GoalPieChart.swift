import Charts
import SwiftUI

struct GoalPieChart: View {
    let progress: GoalProgress
    let segments: [GoalChartSegment]
    let currency: String
    let language: AppLanguage
    let onTap: () -> Void

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 16) {
                Label("goal.monthlyGoal".localized(language), systemImage: "chart.pie.fill")
                    .font(.headline.bold())
                    .symbolRenderingMode(.hierarchical)

                ZStack {
                    Chart(segments) { segment in
                        SectorMark(
                            angle: .value(segment.titleKey.localized(language), max(segment.amount, 0.0001)),
                            innerRadius: .ratio(0.64),
                            angularInset: 2
                        )
                        .foregroundStyle(segment.id == "earned" ? accentColor.gradient : Color.gray.opacity(0.35).gradient)
                    }
                    .chartLegend(.hidden)
                    .frame(height: 220)

                    VStack(spacing: 4) {
                        Text(progress.percentText)
                            .font(.system(size: 34, weight: .heavy, design: .rounded))
                            .contentTransition(.numericText())

                        Text(progress.isGoalReached ? "goal.goalReached".localized(language) : "goal.goalProgress".localized(language))
                            .font(.caption.bold())
                            .foregroundStyle(progress.isGoalReached ? accentColor : .secondary)
                    }
                }

                VStack(spacing: 10) {
                    LabeledContent("goal.earnedThisMonth".localized(language), value: progress.earnedAmount.formattedMoney(currency: currency, language: language))
                    LabeledContent("goal.monthlyGoal".localized(language), value: progress.goalAmount.formattedMoney(currency: currency, language: language))
                    LabeledContent(progress.isGoalReached ? "goal.goalReached".localized(language) : "goal.remainingToGoal".localized(language), value: progress.remainingAmount.formattedMoney(currency: currency, language: language))
                }
                .font(.subheadline)

                Text("goal.tapToViewDetails".localized(language))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
            .glassControl(cornerRadius: 28, tint: accentColor.opacity(0.08))
        }
        .buttonStyle(.plain)
        .animation(.smooth, value: progress)
    }
}
