import SwiftUI

struct ChartCard<Content: View>: View {
    let title: String
    let symbol: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Label(title, systemImage: symbol)
                .font(.headline.bold())
                .symbolRenderingMode(.hierarchical)

            content
                .frame(height: 220)
        }
        .padding(18)
        .surfaceCard(cornerRadius: 28)
    }
}
