import SwiftUI

struct OnboardingHourlyRateView: View {
    @Binding var hourlyRateText: String
    let currency: String
    let language: AppLanguage
    let isValid: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingHeader(
                symbol: "dollarsign.circle.fill",
                title: "onboarding.setupHourlyRate".localized(language),
                subtitle: "onboarding.setupHourlyRateSubtitle".localized(language)
            )

            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 12) {
                    TextField(18.5.appDecimalText(language: language), text: $hourlyRateText)
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
