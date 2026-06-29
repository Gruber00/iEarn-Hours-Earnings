import SwiftUI

struct OnboardingSummaryView: View {
    let selectedLanguage: String
    let currency: String
    let accentColor: String
    let chartStyle: String
    let preferredHand: String
    let monthlyGoalAmount: Double
    let hourlyRate: Double
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingHeader(
                symbol: "checkmark.seal.fill",
                title: "onboarding.summary".localized(language),
                subtitle: "onboarding.completed".localized(language)
            )

            VStack(spacing: 14) {
                LabeledContent("settings.language".localized(language), value: AppLanguage(languageCode: selectedLanguage).displayName)
                LabeledContent("settings.currency".localized(language), value: currency)
                LabeledContent("theme.accentColor".localized(language), value: AppAccentColor(storedValue: accentColor).displayName)
                LabeledContent("chart.style".localized(language), value: ChartStyle(storedValue: chartStyle).displayKey.localized(language))
                LabeledContent("settings.preferredHand".localized(language), value: PreferredHand(storedValue: preferredHand).displayKey.localized(language))
                LabeledContent("goal.monthlyGoal".localized(language), value: monthlyGoalAmount.formattedMoney(currency: currency, language: language))
                LabeledContent("settings.hourlyRate".localized(language), value: hourlyRate.formattedMoney(currency: currency, language: language))
            }
            .padding(18)
            .surfaceCard(cornerRadius: 24)
        }
    }
}
