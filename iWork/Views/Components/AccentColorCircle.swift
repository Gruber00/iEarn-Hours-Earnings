import SwiftUI

struct AccentColorCircle: View {
    let accentColor: AppAccentColor
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(accentColor.swiftUIColor.gradient)
                    .frame(width: 58, height: 58)
                    .shadow(color: accentColor.swiftUIColor.opacity(isSelected ? 0.42 : 0.18), radius: isSelected ? 14 : 6, y: isSelected ? 8 : 3)

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.headline.bold())
                        .foregroundStyle(checkmarkColor)
                        .symbolEffect(.bounce, value: isSelected)
                }
            }
            .padding(8)
            .glassControl(cornerRadius: 40, tint: accentColor.swiftUIColor.opacity(isSelected ? 0.16 : 0.06))
            .scaleEffect(isSelected ? 1.08 : 1)
            .animation(.spring(response: 0.32, dampingFraction: 0.72), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accentColor.displayName)
    }

    private var checkmarkColor: Color {
        switch accentColor {
        case .yellow, .mint, .cyan:
            .black
        default:
            .white
        }
    }
}
