import SwiftUI

struct OnboardingSummaryView: View {
    let selectedLanguage: String
    let preferredHand: String
    let monthlyGoalAmount: Double
    let hourlyRate: Double
    let currency: String
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
                LabeledContent("settings.preferredHand".localized(language), value: PreferredHand(storedValue: preferredHand).displayKey.localized(language))
                LabeledContent("goal.monthlyGoal".localized(language), value: monthlyGoalAmount.formattedMoney(currency: currency, language: language))
                LabeledContent("settings.hourlyRate".localized(language), value: hourlyRate.formattedMoney(currency: currency, language: language))
            }
            .padding(18)
            .surfaceCard(cornerRadius: 24)
        }
    }
}
