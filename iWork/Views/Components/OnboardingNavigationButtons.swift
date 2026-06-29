import SwiftUI

struct OnboardingNavigationButtons: View {
    let language: AppLanguage
    let canGoBack: Bool
    let canAdvance: Bool
    let primaryTitle: String
    let backAction: () -> Void
    let primaryAction: () -> Void

    @Environment(\.appAccentColor) private var accentColor
    @State private var hapticTrigger = 0

    var body: some View {
        HStack(spacing: 16) {
            navigationButton(
                title: "onboarding.back".localized(language),
                systemImage: "chevron.left",
                style: .secondary,
                isEnabled: canGoBack,
                action: backAction
            )
            .opacity(canGoBack ? 1 : 0)
            .accessibilityHidden(!canGoBack)

            navigationButton(
                title: primaryTitle,
                systemImage: "chevron.right",
                style: .primary,
                isEnabled: canAdvance,
                action: primaryAction
            )
        }
        .frame(maxWidth: .infinity)
        .sensoryFeedback(.impact, trigger: hapticTrigger)
    }

    private func navigationButton(
        title: String,
        systemImage: String,
        style: NavigationButtonStyle,
        isEnabled: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            guard isEnabled else { return }
            hapticTrigger += 1
            action()
        } label: {
            HStack(spacing: 8) {
                if style == .secondary {
                    Image(systemName: systemImage)
                        .font(.subheadline.weight(.bold))
                }

                Text(title)
                    .font(.headline.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                if style == .primary {
                    Image(systemName: systemImage)
                        .font(.subheadline.weight(.bold))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .foregroundStyle(style.foregroundColor(accentColor: accentColor))
            .background(style.backgroundColor(accentColor: accentColor), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .glassControl(cornerRadius: 22, tint: style.glassTint(accentColor: accentColor))
            .contentShape(.rect)
        }
        .buttonStyle(OnboardingNavigationButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.52)
        .animation(.smooth, value: accentColor)
    }
}

private enum NavigationButtonStyle {
    case primary
    case secondary

    func foregroundColor(accentColor: Color) -> Color {
        switch self {
        case .primary:
            .white
        case .secondary:
            accentColor
        }
    }

    func backgroundColor(accentColor: Color) -> Color {
        switch self {
        case .primary:
            accentColor.opacity(0.90)
        case .secondary:
            accentColor.opacity(0.08)
        }
    }

    func glassTint(accentColor: Color) -> Color {
        switch self {
        case .primary:
            accentColor.opacity(0.34)
        case .secondary:
            accentColor.opacity(0.10)
        }
    }
}

private struct OnboardingNavigationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.24, dampingFraction: 0.72), value: configuration.isPressed)
    }
}
