import SwiftUI

struct GlassFloatingButton: View {
    let isAnimating: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.green)
                .frame(width: 74, height: 74)
                .symbolEffect(.bounce, value: isAnimating)
                .scaleEffect(isAnimating ? 1.05 : 1)
        }
        .glassControl(cornerRadius: 37, tint: .green.opacity(0.12))
        .shadow(color: .green.opacity(0.32), radius: 20, x: 0, y: 12)
        .accessibilityLabel("Arbeitszeit hinzufügen")
    }
}
