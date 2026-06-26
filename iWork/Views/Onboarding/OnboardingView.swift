import SwiftUI

struct OnboardingView: View {
    let settings: SettingsModel
    @State private var viewModel: OnboardingViewModel

    init(settings: SettingsModel) {
        self.settings = settings
        _viewModel = State(initialValue: OnboardingViewModel(settings: settings))
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        let language = viewModel.language

        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                ProgressView(value: viewModel.progress)
                    .tint(.green)
                    .padding(.horizontal, 28)
                    .padding(.top, 20)

                Group {
                    switch viewModel.step {
                    case .welcome:
                        OnboardingWelcomeView(language: language)
                    case .language:
                        OnboardingLanguageView(selectedLanguage: $viewModel.selectedLanguage, language: language)
                    case .hand:
                        OnboardingHandView(preferredHand: $viewModel.preferredHand, language: language)
                    case .goal:
                        OnboardingGoalView(
                            monthlyGoalText: $viewModel.monthlyGoalText,
                            currency: settings.currency,
                            language: language,
                            isValid: viewModel.canAdvance
                        )
                    case .hourlyRate:
                        OnboardingHourlyRateView(
                            hourlyRateText: $viewModel.hourlyRateText,
                            currency: settings.currency,
                            language: language,
                            isValid: viewModel.canAdvance
                        )
                    case .summary:
                        OnboardingSummaryView(
                            selectedLanguage: viewModel.selectedLanguage,
                            preferredHand: viewModel.preferredHand,
                            monthlyGoalAmount: viewModel.monthlyGoalAmount,
                            hourlyRate: viewModel.hourlyRate,
                            currency: settings.currency,
                            language: language
                        )
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
                .animation(.smooth, value: viewModel.step)

                controls(language: language)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
        .environment(\.locale, language.locale)
    }

    @ViewBuilder
    private func controls(language: AppLanguage) -> some View {
        HStack(spacing: 14) {
            if viewModel.canGoBack {
                Button("onboarding.back".localized(language)) {
                    withAnimation(.snappy) {
                        viewModel.goBack()
                    }
                }
                .glassButtonIfAvailable()
            }

            Button(primaryButtonTitle(language: language)) {
                withAnimation(.snappy) {
                    if viewModel.step == .summary {
                        viewModel.complete(settings: settings)
                    } else {
                        viewModel.goNext()
                    }
                }
            }
            .glassProminentIfAvailable()
            .disabled(!viewModel.canAdvance)
            .frame(maxWidth: .infinity)
        }
    }

    private func primaryButtonTitle(language: AppLanguage) -> String {
        switch viewModel.step {
        case .welcome:
            "onboarding.getStarted".localized(language)
        case .summary:
            "onboarding.startApp".localized(language)
        default:
            "onboarding.next".localized(language)
        }
    }
}

struct OnboardingHeader: View {
    let symbol: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: symbol)
                .font(.system(size: 54, weight: .bold))
                .foregroundStyle(.green)
                .symbolRenderingMode(.hierarchical)

            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.largeTitle.bold())

                Text(subtitle)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
