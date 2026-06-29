import SwiftUI

struct RoundAllWorkEntriesButton: View {
    let language: AppLanguage
    let action: () -> Void

    @Environment(\.appAccentColor) private var accentColor
    @State private var showingConfirmation = false
    @State private var isPressed = false

    var body: some View {
        Button {
            showingConfirmation = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "clock.badge.checkmark.fill")
                    .font(.title3)
                    .foregroundStyle(accentColor)
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 38, height: 38)
                    .background(accentColor.opacity(0.12), in: Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text("settings.roundAllEntries".localized(language))
                        .font(.headline)
                        .foregroundStyle(.primary)

                    Text("settings.roundAllEntriesSubtitle".localized(language))
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 10)

                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
            .contentShape(.rect)
            .surfaceCard(cornerRadius: 22)
            .scaleEffect(isPressed ? 0.98 : 1)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.spring(response: 0.22, dampingFraction: 0.8)) {
                        isPressed = false
                    }
                }
        )
        .confirmationDialog(
            "settings.roundAllEntriesConfirmTitle".localized(language),
            isPresented: $showingConfirmation,
            titleVisibility: .visible
        ) {
            Button("settings.roundAllEntriesConfirmAction".localized(language)) {
                action()
            }

            Button("common.cancel".localized(language), role: .cancel) {}
        } message: {
            Text("settings.roundAllEntriesConfirmMessage".localized(language))
        }
        .animation(.smooth, value: accentColor)
    }
}
