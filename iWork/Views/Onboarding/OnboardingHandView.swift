import SwiftUI

struct OnboardingHandView: View {
    @Binding var preferredHand: String
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingHeader(
                symbol: "hand.tap.fill",
                title: "onboarding.choosePreferredHand".localized(language),
                subtitle: "onboarding.choosePreferredHandSubtitle".localized(language)
            )

            VStack(spacing: 12) {
                ForEach(PreferredHand.allCases) { hand in
                    Button {
                        withAnimation(.snappy) {
                            preferredHand = hand.rawValue
                        }
                    } label: {
                        HStack {
                            Text(hand.displayKey.localized(language))
                                .font(.headline)
                            Spacer()
                            if preferredHand == hand.rawValue {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding(16)
                        .surfaceCard(cornerRadius: 18)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
