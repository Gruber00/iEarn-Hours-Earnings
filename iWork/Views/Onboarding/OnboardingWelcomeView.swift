import SwiftUI

struct OnboardingWelcomeView: View {
    let language: AppLanguage

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "clock.badge.checkmark")
                .font(.system(size: 88, weight: .bold))
                .foregroundStyle(.green)
                .symbolRenderingMode(.hierarchical)
                .symbolEffect(.bounce, value: language.languageCode)

            VStack(spacing: 10) {
                Text("onboarding.welcomeTitle".localized(language))
                    .font(.largeTitle.bold())

                Text("onboarding.welcomeSubtitle".localized(language))
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(28)
        .glassControl(cornerRadius: 32, tint: .green.opacity(0.08))
    }
}
