import SwiftUI

struct ChartCard<Content: View>: View {
    let title: String
    let symbol: String
    let tapHint: String?
    @ViewBuilder let content: Content

    init(title: String, symbol: String, tapHint: String? = nil, @ViewBuilder content: () -> Content) {
        self.title = title
        self.symbol = symbol
        self.tapHint = tapHint
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Label(title, systemImage: symbol)
                    .font(.headline.bold())
                    .symbolRenderingMode(.hierarchical)

                Spacer()

                if tapHint != nil {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                }
            }

            content
                .frame(height: 220)

            if let tapHint {
                Text(tapHint)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .surfaceCard(cornerRadius: 28)
    }
}
