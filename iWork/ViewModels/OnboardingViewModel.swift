import Foundation
import Observation

@Observable
final class OnboardingViewModel {
    var step: OnboardingStep = .welcome
    var selectedLanguage: String
    var preferredHand: String
    var monthlyGoalText: String
    var hourlyRateText: String

    init(settings: SettingsModel) {
        selectedLanguage = settings.selectedLanguage
        preferredHand = settings.preferredHand
        monthlyGoalText = settings.monthlyGoalAmount.appDecimalText(language: settings.appLanguage)
        hourlyRateText = settings.hourlyRate.appDecimalText(language: settings.appLanguage)
    }

    var language: AppLanguage {
        AppLanguage(languageCode: selectedLanguage)
    }

    var progress: Double {
        Double(step.index + 1) / Double(OnboardingStep.allCases.count)
    }

    var canGoBack: Bool {
        step.index > 0
    }

    var canAdvance: Bool {
        switch step {
        case .goal:
            validAmount(from: monthlyGoalText) != nil
        case .hourlyRate:
            validAmount(from: hourlyRateText) != nil
        default:
            true
        }
    }

    var monthlyGoalAmount: Double {
        validAmount(from: monthlyGoalText) ?? GoalService.defaultGoalAmount
    }

    var hourlyRate: Double {
        validAmount(from: hourlyRateText) ?? 18.5
    }

    func goBack() {
        guard let previous = OnboardingStep(rawValue: step.rawValue - 1) else { return }
        step = previous
    }

    func goNext() {
        guard canAdvance, let next = OnboardingStep(rawValue: step.rawValue + 1) else { return }
        step = next
    }

    func complete(settings: SettingsModel) {
        settings.selectedLanguage = selectedLanguage
        settings.preferredHand = preferredHand
        settings.monthlyGoalAmount = monthlyGoalAmount
        settings.hourlyRate = hourlyRate
        settings.hasCompletedOnboarding = true
    }

    func validAmount(from text: String) -> Double? {
        let normalized = text.replacingOccurrences(of: ",", with: ".")
        guard let amount = Double(normalized), amount.isFinite, amount > 0 else { return nil }
        return amount
    }
}

enum OnboardingStep: Int, CaseIterable {
    case welcome
    case language
    case hand
    case goal
    case hourlyRate
    case summary

    var index: Int { rawValue }
}
