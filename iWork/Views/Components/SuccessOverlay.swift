import SwiftUI

struct SuccessOverlay: View {
    let isVisible: Bool
    let message: String
    let trigger: Int

    @Environment(\.appAccentColor) private var accentColor

    var body: some View {
        if isVisible {
            ZStack {
                Color.black.opacity(0.28)
                    .ignoresSafeArea()

                VStack(spacing: 18) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 118, weight: .bold))
                        .foregroundStyle(accentColor)
                        .symbolRenderingMode(.hierarchical)
                        .symbolEffect(.bounce, value: trigger)

                    Text(message)
                        .font(.title2.bold())
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 10)
                }
                .padding(30)
                .frame(maxWidth: 330)
                .glassControl(cornerRadius: 34, tint: accentColor.opacity(0.10))
                .scaleEffect(isVisible ? 1 : 0.82)
                .opacity(isVisible ? 1 : 0)
            }
            .transition(.opacity.combined(with: .scale(scale: 0.86)))
            .zIndex(20)
            .animation(.smooth, value: accentColor)
        }
    }
}
