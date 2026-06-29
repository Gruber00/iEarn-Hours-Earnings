import SwiftUI

struct SheetToolbarButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    @Environment(\.appAccentColor) private var accentColor
    @State private var isPressed = false

    var body: some View {
        Button {
            withAnimation(.spring(response: 0.24, dampingFraction: 0.72)) {
                isPressed = true
            }
            action()
            Task { @MainActor in
                try? await Task.sleep(for: .milliseconds(140))
                isPressed = false
            }
        } label: {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(accentColor)
                .symbolRenderingMode(.hierarchical)
                .scaleEffect(isPressed ? 0.94 : 1)
        }
        .glassButtonIfAvailable()
        .animation(.smooth, value: accentColor)
    }
}
