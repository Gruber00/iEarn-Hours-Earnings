import SwiftUI

struct OnboardingLanguageView: View {
    @Binding var selectedLanguage: String
    let language: AppLanguage

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingHeader(
                symbol: "globe",
                title: "onboarding.chooseLanguage".localized(language),
                subtitle: "onboarding.chooseLanguageSubtitle".localized(language)
            )

            VStack(spacing: 12) {
                ForEach(AppLanguage.allCases) { appLanguage in
                    Button {
                        withAnimation(.snappy) {
                            selectedLanguage = appLanguage.languageCode
                        }
                    } label: {
                        HStack {
                            Text(appLanguage.displayName)
                                .font(.headline)
                            Spacer()
                            if selectedLanguage == appLanguage.languageCode {
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
