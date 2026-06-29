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
        let accentColor = ThemeService.accentColor(for: viewModel.accentColor)

        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                ProgressView(value: viewModel.progress)
                    .tint(accentColor)
                    .padding(.horizontal, 28)
                    .padding(.top, 20)

                Group {
                    switch viewModel.step {
                    case .welcome:
                        OnboardingWelcomeView(language: language)
                    case .language:
                        OnboardingLanguageView(selectedLanguage: $viewModel.selectedLanguage, language: language)
                    case .currency:
                        OnboardingCurrencyView(currency: $viewModel.currency, language: language)
                    case .accentColor:
                        OnboardingAccentColorView(selectedAccentColor: $viewModel.accentColor, language: language)
                    case .chartStyle:
                        OnboardingChartStyleView(chartStyle: $viewModel.chartStyle, language: language)
                    case .hand:
                        OnboardingHandView(preferredHand: $viewModel.preferredHand, language: language)
                    case .goal:
                        OnboardingGoalView(
                            monthlyGoalText: $viewModel.monthlyGoalText,
                            currency: viewModel.currency,
                            language: language,
                            isValid: viewModel.canAdvance
                        )
                    case .hourlyRate:
                        OnboardingHourlyRateView(
                            hourlyRateText: $viewModel.hourlyRateText,
                            currency: viewModel.currency,
                            language: language,
                            isValid: viewModel.canAdvance
                        )
                    case .summary:
                        OnboardingSummaryView(
                            selectedLanguage: viewModel.selectedLanguage,
                            currency: viewModel.currency,
                            accentColor: viewModel.accentColor,
                            chartStyle: viewModel.chartStyle,
                            preferredHand: viewModel.preferredHand,
                            monthlyGoalAmount: viewModel.monthlyGoalAmount,
                            hourlyRate: viewModel.hourlyRate,
                            language: language
                        )
                    }
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .transition(.opacity.combined(with: .move(edge: .trailing)))
                .animation(.smooth, value: viewModel.step)

                controls(language: language)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 20)
            }
        }
        .environment(\.locale, language.locale)
        .environment(\.appAccentColor, accentColor)
        .tint(accentColor)
        .animation(.smooth, value: viewModel.accentColor)
    }

    private func controls(language: AppLanguage) -> some View {
        OnboardingNavigationButtons(
            language: language,
            canGoBack: viewModel.canGoBack,
            canAdvance: viewModel.canAdvance,
            primaryTitle: primaryButtonTitle(language: language)
        ) {
            withAnimation(.snappy) {
                viewModel.goBack()
            }
        } primaryAction: {
            withAnimation(.snappy) {
                if viewModel.step == .summary {
                    viewModel.complete(settings: settings)
                } else {
                    viewModel.goNext()
                }
            }
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
    @Environment(\.appAccentColor) private var accentColor

    let symbol: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Image(systemName: symbol)
                .font(.system(size: 54, weight: .bold))
                .foregroundStyle(accentColor)
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
