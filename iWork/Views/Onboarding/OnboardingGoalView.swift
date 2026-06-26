import SwiftUI

struct OnboardingGoalView: View {
    @Binding var monthlyGoalText: String
    let currency: String
    let language: AppLanguage
    let isValid: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingHeader(
                symbol: "target",
                title: "onboarding.setupMonthlyGoal".localized(language),
                subtitle: "onboarding.setupMonthlyGoalSubtitle".localized(language)
            )

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    TextField(GoalService.defaultGoalAmount.appDecimalText(language: language), text: $monthlyGoalText)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    Text(currency)
                        .font(.title2.bold())
                        .foregroundStyle(.secondary)
                }
                .padding(18)
                .glassControl(cornerRadius: 24, tint: .green.opacity(0.08))

                if !isValid {
                    Text("onboarding.invalidAmount".localized(language))
                        .font(.caption)
                        .foregroundStyle(.red)
                }
            }
        }
    }
}
