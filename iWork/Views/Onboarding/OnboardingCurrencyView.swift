import SwiftUI

struct OnboardingCurrencyView: View {
    @Binding var currency: String
    let language: AppLanguage

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingHeader(
                symbol: "dollarsign.circle.fill",
                title: "onboarding.chooseCurrency".localized(language),
                subtitle: "onboarding.chooseCurrencySubtitle".localized(language)
            )

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 92), spacing: 14)], spacing: 14) {
                ForEach(SettingsViewModel.currencies, id: \.self) { currencyOption in
                    Button {
                        withAnimation(.snappy) {
                            currency = currencyOption
                        }
                    } label: {
                        VStack(spacing: 10) {
                            Text(currencyOption)
                                .font(.title2.bold())
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)

                            if currency == currencyOption {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3)
                                    .foregroundStyle(accentColor)
                                    .symbolEffect(.bounce, value: currency)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 78)
                        .foregroundStyle(currency == currencyOption ? accentColor : .primary)
                        .glassControl(cornerRadius: 22, tint: (currency == currencyOption ? accentColor : Color.clear).opacity(0.10))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
