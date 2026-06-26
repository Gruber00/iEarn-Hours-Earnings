import SwiftUI

struct CreditsFooter: View {
    var body: some View {
        VStack(spacing: 5) {
            Text("Designed & Developed by Felix Leonhard Gruber")
                .font(.footnote.weight(.medium))

            Text("© 2026 All rights reserved")
                .font(.caption2)
        }
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .listRowInsets(EdgeInsets(top: 22, leading: 20, bottom: 28, trailing: 20))
        .listRowBackground(Color.clear)
    }
}
