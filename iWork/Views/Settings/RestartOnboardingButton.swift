import SwiftUI

struct RestartOnboardingButton: View {
    let language: AppLanguage
    let action: () -> Void

    @State private var showingConfirmation = false

    var body: some View {
        Button {
            showingConfirmation = true
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "arrow.clockwise.circle.fill")
                    .font(.title3.bold())
                    .foregroundStyle(.red)
                    .symbolRenderingMode(.hierarchical)

                Text("onboarding.restartButton".localized(language))
                    .font(.headline)
                    .foregroundStyle(.red)

                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .glassControl(cornerRadius: 22, tint: Color.red.opacity(0.08))
        }
        .buttonStyle(.plain)
        .confirmationDialog(
            "onboarding.restartTitle".localized(language),
            isPresented: $showingConfirmation,
            titleVisibility: .visible
        ) {
            Button("onboarding.restartConfirm".localized(language), role: .destructive) {
                action()
            }

            Button("common.cancel".localized(language), role: .cancel) { }
        } message: {
            Text("onboarding.restartMessage".localized(language))
        }
    }
}
